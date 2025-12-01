//
//  ContentView.swift
//  BrainLock
//

import SwiftUI

struct ContentView: View {
    // Estado de splash/animación
    @State private var isLoading = true
    @State private var scale: CGFloat = 1.0
    @State private var isCheckingSession = false
    @State private var validatedRole: Roles = Roles.GUEST

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            if isLoading {
                ZStack {
                    Image("Portada3")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()

                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .offset(y: -100)
                        .scaleEffect(scale)
                        .onAppear {
                            // Animación de pulso infinito
                            withAnimation(.easeInOut(duration: 5.0).repeatForever(autoreverses: true)) {
                                scale = 2.05
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                                withAnimation(.easeInOut) {
                                    isLoading = false
                                }
                            }
                        }
                }
            } else if isCheckingSession {
                ProgressView("Validando sesión...")
                    .foregroundColor(.white)
            } else {
                rootDecisionView
            }
        }.onAppear {
            checkSession()
        }
    }
    
    // MARK: - Routing Logic
        @ViewBuilder
        private var rootDecisionView: some View {
            switch validatedRole {
                case Roles.USER:
                    DonationView()
                case Roles.ADMIN:
                    FolioControl()
                default:
                VistaInicio(validatedRole: $validatedRole)
            }
        }

        // MARK: - Validate Session
        private func checkSession() {
            isCheckingSession = true

            Task {
                do {
                    let result = try await AuthAPI.validateSession()
                    DispatchQueue.main.async {
                        validatedRole = Roles(from: result.role)
                        isCheckingSession = false
                    }
                } catch {
                    print(error.localizedDescription)
                    // Session invalid → go to login
                    DispatchQueue.main.async {
                        validatedRole = Roles.GUEST
                        isCheckingSession = false
                    }
                }
            }
        }
}

#Preview {
    ContentView()
}
