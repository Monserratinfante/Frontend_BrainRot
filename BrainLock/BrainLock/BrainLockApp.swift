//
//  BrainLockApp.swift
//  BrainLock
//
//  Created by Alumno on 21/10/25.
//

import SwiftUI

@main
struct BrainLockApp: App {
    @StateObject var authModel = AuthStore()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                VistaInicio()              // desde aquí navegas a LoginRegisterView()
            }
            .environmentObject(authModel)
        }
    }
}
