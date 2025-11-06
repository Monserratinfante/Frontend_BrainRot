//
//  DonationsView.swift
//  BrainLock
//
//  Created by Fatima Cruz Hernandez on 27/10/25.
//

import SwiftUI

struct DonationsView: View {
    // Si luego quieres “Salir”, pásame un closure. Por ahora no es necesario.
    var body: some View {
        ZStack {
            // Fondo
            if let _ = UIImage(named: "Colores") {
                Image("Colores")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            } else {
                Color.black.ignoresSafeArea()
            }

            VStack(spacing: 16) {

                // Encabezado reutilizable
                BaseHeader(title: "Donaciones")

                // Tarjeta ART.1 (como en tu mock)
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("ART.1").font(.headline).foregroundColor(.white)
                        Text("Descripción").foregroundColor(.white)
                        Text("Peso").foregroundColor(.white)
                        Text("Tipo").foregroundColor(.white)
                    }
                    Spacer(minLength: 12)
                    Group {
                        if UIImage(named: "Box") != nil {
                            Image("Box").resizable().scaledToFit().frame(width: 70, height: 70)
                        } else {
                            Image(systemName: "shippingbox.fill")
                                .resizable().scaledToFit().frame(width: 56, height: 56)
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(14)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(.white, lineWidth: 2)
                )
                .padding(.horizontal, 20)

                // Botón “+ Agregar artículo”
                Button {
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 28, height: 28)
                        Text("Agregar artículo")
                            .foregroundColor(.white)
                            .font(.headline)
                        Spacer()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.08))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(0.18), lineWidth: 1)
                    )
                    .padding(.horizontal, 20)
                }
                .buttonStyle(.plain)
            }

            // Botón flotante “Enviar donación”
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        // Simula envío (alert / print)
                    } label: {
                        Text("Enviar\ndonación")
                            .multilineTextAlignment(.center)
                            .font(.headline).bold()
                            .foregroundColor(.white)
                            .padding(.vertical, 14)
                            .padding(.horizontal, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(red: 0.00, green: 0.55, blue: 0.60))
                            )
                            .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 6)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 26)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
