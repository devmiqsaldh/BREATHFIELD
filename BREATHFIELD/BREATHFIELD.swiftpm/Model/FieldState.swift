//
//  FieldState.swift
//  BREATHFIELD
//
//  Created by Miqueias Saldanha on 21/01/26.
//

import SwiftUI

/// Represents the current coherence state of the field/experience.
///
/// The raw value (`Int`) can be used for persistence, sorting, or thresholds.
/// States progress from more chaotic (lower) to more stable (higher).
enum FieldState: Int {
    /// Highly irregular, incoherent state.
    case chaotic
    /// Trending away from stability, but less chaotic than `chaotic`.
    case destabilizing
    /// Recovering toward stability.
    case stabilizing
    /// Mostly synchronized/coherent.
    case coherent
    /// Fully stable/coherent state.
    case stable

    /// A human-readable label for the state, suitable for UI.
    var description: String {
        switch self {
        case .chaotic: return "Chaotic"
        case .destabilizing: return "Destabilizing"
        case .stabilizing: return "Stabilizing"
        case .coherent: return "Coherent"
        case .stable: return "Stable"
        }
    }

    /// A representative color for the state, used for visual feedback.
    var color: Color {
        switch self {
        case .chaotic: return .red
        case .destabilizing: return .red.opacity(0.7)
        case .stabilizing: return .orange
        case .coherent: return .yellow
        case .stable: return .green
        }
    }
}

