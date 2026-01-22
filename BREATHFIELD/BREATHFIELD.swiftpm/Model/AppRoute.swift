//
//  AppRoute.swift
//  BREATHFIELD
//
//  Created by Miqueias Saldanha on 21/01/26.
//

import Foundation

/// High-level navigation destinations for the app.
///
/// Use `AppRoute` as the type for `NavigationStack` paths or programmatic routing.
/// Conforming to `Hashable` enables it to be pushed onto a navigation path.
enum AppRoute: Hashable {
    /// Route that presents the interactive breathing/field experience screen.
    case interactive
}

