//
//  FieldViewModel.swift
//  BREATHFIELD
//
//  Created by Miqueias Saldanha on 12/01/26.
//
//

import SwiftUI
import UIKit
import Combine

/// Coordinates the interactive particle field state and user interactions.
/// Publishes state changes for the UI and relays gestures to the SpriteKit scene.
@MainActor
/// View model for the field experience, exposing state and controlling transitions.
final class FieldViewModel: ObservableObject {

    /// The current high-level state of the field. Published read-only to the UI.
    @Published private(set) var state: FieldState = .chaotic
    /// Controls presentation of the stable info overlay once stability is locked.
    @Published var showStableInfo = false

    /// The SpriteKit scene that renders and reports metrics for the field.
    let scene: InteractiveParticleScene

    /// Aggregated calmness factor derived from gesture input (0...1).
    private var calmness: CGFloat = 0
    /// Timestamp of the most recent gesture update.
    private var lastGestureTime = Date()
    /// Prevents further state changes once stable has been achieved.
    private var stableLocked = false

    /// Start time for the stabilizing phase, used to debounce transitions.
    private var stabilizingStart: Date?
    /// Start time for the coherent phase, used to ensure sustained coherence.
    private var coherentStart: Date?

    /// Initializes the view model and wires scene metric updates to state syncing.
    /// The scene is created and its metrics are observed on the main actor.
    init() {
        scene = InteractiveParticleScene()

        scene.onMetricsUpdate = { [weak self] metrics in
            self?.syncState(with: metrics)
        }
    }

    /// Processes a gesture update and relays it to the scene while adjusting calmness.
    /// - Parameters:
    ///   - velocity: Gesture velocity magnitude used to modulate calmness.
    ///   - location: Touch location in view coordinates.
    ///   - translation: Gesture translation used to compute a field vector.
    func registerGesture(
        velocity: CGFloat,
        location: CGPoint,
        translation: CGSize
    ) {
        guard !stableLocked else { return }

        lastGestureTime = Date()

        let normalizedVelocity = (velocity / 900).clamped(to: 0...1)

        if normalizedVelocity < 0.25 {
            calmness += 0.01
        } else {
            calmness -= normalizedVelocity * 0.04
        }

        calmness = calmness.clamped(to: 0...1)

        scene.applyGesture(
            location: location,
            translation: CGVector(
                dx: translation.width * 0.02,
                dy: translation.height * 0.02
            ),
            calmness: calmness,
            velocity: velocity
        )
    }

    /// Ends the current gesture interaction in the scene.
    func stopGesture() {
        scene.stopGesture()
    }

    /// Resets the field and view model to the initial chaotic state.
    /// Clears timers, flags, calmness, and scene state.
    func reset() {
        calmness = 0
        stableLocked = false
        showStableInfo = false
        state = .chaotic

        stabilizingStart = nil
        coherentStart = nil

        scene.reset()
    }

    /// Synchronizes the high-level state machine with scene-reported metrics.
    /// Applies timing thresholds to avoid flicker and locks stability when sustained.
    /// - Parameter metrics: Live metrics reported by the interactive scene.
    private func syncState(
        with metrics: InteractiveParticleScene.Metrics
    ) {
        guard !stableLocked else { return }

        let now = Date()
        let timeWithoutGesture = now.timeIntervalSince(lastGestureTime)

        let order = metrics.fieldOrder
        let structure = metrics.structuralOrder
        let isGestureActive = metrics.isGestureActive

        if order < 0.2 || timeWithoutGesture > 2 {
            state = .chaotic
            stabilizingStart = nil
            coherentStart = nil
            return
        }

        if !isGestureActive && structure < 0.4 {
            state = .destabilizing
            stabilizingStart = nil
            coherentStart = nil
            return
        }

        if structure < 0.6 {
            state = .stabilizing

            if stabilizingStart == nil {
                stabilizingStart = now
            }

            coherentStart = nil
            return
        }

        if structure < 0.9 {
            state = .coherent

            if coherentStart == nil {
                coherentStart = now
            }

            if let start = coherentStart,
               now.timeIntervalSince(start) < 4 {
                return
            }

            return
        }

        state = .stable
        lockStable()
    }

    /// Locks the stable state and schedules the stable info overlay presentation.
    private func lockStable() {
        guard !stableLocked else { return }

        stableLocked = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.showStableInfo = true
        }
    }
}
