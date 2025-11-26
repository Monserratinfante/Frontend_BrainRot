//
//  DonationsView.swift
//  BrainLock
//
//  Created by Fatima Cruz Hernandez on 27/10/25.
//

import SwiftUI

struct Donacion: Identifiable {
    let id = UUID()
    var foto: Image? = nil
    var clasificacion: String
    var descripcion: String
    var peso: String          // Ej: "10 kg" o "500 g"
    var estado: String? = nil // "En revisión", "Aceptada", "Cancelada"
    var imagenes: [UIImage] = []
}

struct DonationView: View {
    @State private var donaciones: [Donacion] = []
    @State private var mostrarAgregar = false
    @State private var mostrarConfirmacion = false
    @State private var donacionSeleccionada: Donacion? = nil

    @State private var irADonacionEnviada = false
    @State private var irABasares = false

    private let azulOscuro = Color(red: 0.0039, green: 0.227, blue: 0.3647)

    var body: some View {
        NavigationStack {
            ZStack {

                azulOscuro
                    .ignoresSafeArea()

                Image("Fondo")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack {
                    BaseHeader(title: "Donaciones")

                    // Botón de agregar donación arriba
                    Button {
                        mostrarAgregar = true
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(azulOscuro)
                            Text("Agregar donación")
                                .foregroundColor(azulOscuro)
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
                                .stroke(Color.gray.opacity(0.18), lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                    }
                    .buttonStyle(.plain)

                    // Lista de donaciones
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(donaciones) { item in
                                HStack(alignment: .center) {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(item.clasificacion)
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        Text(item.descripcion)
                                            .foregroundColor(.black)
                                        Text("Peso: \(item.peso)")
                                            .foregroundColor(.black)
                                        if let estado = item.estado {
                                            Text("Estado: \(estado)")
                                                .foregroundColor(.green)
                                        }
                                    }
                                    Spacer(minLength: 12)
                                    Group {
                                        if let foto = item.foto {
                                            foto
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 70, height: 70)
                                                .cornerRadius(6)
                                        } else {
                                            Image(systemName: "shippingbox.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 56, height: 56)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                                .padding(14)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(.gray, lineWidth: 2)
                                )
                                .padding(.horizontal, 20)
                            }
                        }
                    }

                    // Botón “Enviar donación” abajo
                    Button {
                        guard let ultima = donaciones.last else { return }
                        donacionSeleccionada = ultima
                        mostrarConfirmacion = true
                    } label: {
                        Text("Enviar donación")
                            .multilineTextAlignment(.center)
                            .font(.headline).bold()
                            .foregroundColor(azulOscuro)
                            .padding(.vertical, 14)
                            .padding(.horizontal, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(donaciones.isEmpty
                                          ? .white
                                          : Color(red: 0.00, green: 0.55, blue: 0.60))
                            )
                            .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 6)
                    }
                    .padding(.bottom, 26)
                    .disabled(donaciones.isEmpty)
                }
            }
            // Alerta de confirmación
            .alert("¿Estás seguro de enviar la donación?", isPresented: $mostrarConfirmacion) {
                Button("Cancelar", role: .cancel) {}

                Button("Enviar") {
                    guard let seleccionada = donacionSeleccionada else { return }

                    // Actualizar estado localmente
                    if let idx = donaciones.firstIndex(where: { $0.id == seleccionada.id }) {
                        donaciones[idx].estado = "En revisión"
                    }

                    let pesoKg = pesoEnKg(desde: seleccionada.peso)
                    print("Peso calculado en kg: \(pesoKg)")

                    //  Llamada al backend AQUÍ
                    Task {
                        var urls: [String] = []

                        // Mientras no tengas /upload implementado, usamos URLs mock
                        if !seleccionada.imagenes.isEmpty {
                            urls = seleccionada.imagenes.enumerated().map { index, _ in
                                "https://example.com/mock-image-\(index).jpg"
                            }
                        }

                        let payload = CreateDonationPayload(
                            description: seleccionada.descripcion,
                            weight: pesoKg,
                            category: seleccionada.clasificacion,
                            images: urls
                        )

                        do {
                            let _ = try await postDonation(payload: payload)
                            print(" Donación enviada al backend con \(urls.count) imágenes")
                        } catch {
                            print("Error enviando donación:", error)
                        }
                    }

                    // Navegación según peso
                    if pesoKg > 50 {
                        irADonacionEnviada = true
                    } else {
                        irABasares = true
                    }
                }
            }

            // Navegación a la vista de donación enviada
            .navigationDestination(isPresented: $irADonacionEnviada) {
                if let donacion = donacionSeleccionada {
                    DonationEnviadaView(donacion: donacion)
                } else {
                    Text("Error: No hay donación seleccionada")
                }
            }

            // Navegación a bazares (usamos tu vista ya hecha)
            .navigationDestination(isPresented: $irABasares) {
                Basar1View()   // tu bazar principal
            }

            .navigationBarBackButtonHidden(true)
        }
        // Pantalla completa para agregar donación
        .fullScreenCover(isPresented: $mostrarAgregar) {
            AgregarDonacionView { nueva in
                donaciones.append(nueva)
            }
        }
    }

    // MARK: - Helper para convertir "10 kg" / "500 g" a kg
    private func pesoEnKg(desde texto: String) -> Double {
        let partes = texto.split(separator: " ")
        guard let numeroStr = partes.first else { return 0 }

        let valor = Double(
            numeroStr
                .replacingOccurrences(of: ",", with: ".")
        ) ?? 0

        if partes.count > 1 {
            let unidad = partes[1].lowercased()
            if unidad.contains("g") {
                return valor / 1000.0
            }
        }
        return valor // se asume kg
    }
}

#Preview {
    DonationView()
}
