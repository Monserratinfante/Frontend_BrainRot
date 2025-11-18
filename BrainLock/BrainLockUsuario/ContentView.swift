//
//  ContentView.swift
//  BrainLock
//

import SwiftUI

struct ContentView: View {
    // Estado de splash/animación
    @State private var isLoading = true
    @State private var scale: CGFloat = 1.0

    var body: some View {
        ZStack {
            if isLoading {
                ZStack {
                    Image("Portada")
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
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation(.easeInOut) {
                                    isLoading = false
                                }
                            }
                        }
                }
            } else {
                VistaInicio()
                    .transition(.opacity)
            }
        }
    }
}


#Preview {
    ContentView()
}
