//
//  ContentView.swift
//  BrainLock
//

import SwiftUI

struct ContentView: View {
    // Estado de splash/animación
    @State private var isLoading = true
    @State private var scale: CGFloat = 1.0
    
    // Estado de sesión
    @State private var isCheckingSession = false
    @State private var validatedRole: Roles = Roles.GUEST
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                if isLoading {
                    // Splash / animación
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
                                // Animación del logo
                                withAnimation(.easeInOut(duration: 5.0).repeatForever(autoreverses: true)) {
                                    scale = 2.05
                                }
                                
                                // Fin de splash tras 3 segundos
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    withAnimation(.easeInOut) {
                                        isLoading = false
                                    }
                                }
                            }
                    }
                } else if isCheckingSession {
                    // Indicador mientras se valida sesión
                    ProgressView("Validando sesión...")
                        .foregroundColor(.white)
                }else {
                    rootDecisionView
                        .transition(.opacity)
                }
            }
        }
        .onAppear {
            checkSession()
        }
    }
    
    // MARK: - Routing Logic según rol
    @ViewBuilder
    private var rootDecisionView: some View {
        switch validatedRole {
        case Roles.USER:
            BarraView2()
        case Roles.ADMIN:
            BarraView()
        default:
            VistaInicio()
        }
    }
    
    // MARK: - Validar sesión
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
                // Sesión inválida → usuario invitado
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
