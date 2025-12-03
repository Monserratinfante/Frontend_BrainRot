//
//  ContentView.swift
//  BrainLock
//

import SwiftUI

struct ContentView: View {
    @State private var isLoading = true
    @State private var scale: CGFloat = 1.0

    // ESTADO GLOBAL DEL LOGIN
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    var body: some View {
        NavigationStack {
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
                                withAnimation(.easeInOut(duration: 5.0).repeatForever(autoreverses: true)) {
                                    scale = 2.05
                                }

                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    withAnimation(.easeInOut) {
                                        isLoading = false
                                    }
                                }
                            }
                    }
                } else {
                    // AHORA LA RAÍZ CAMBIA SEGÚN LOGIN
                    if isLoggedIn {
                        BarraView2()
                            .transition(.opacity)
                    } else {
                        VistaInicio()
                            .transition(.opacity)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
