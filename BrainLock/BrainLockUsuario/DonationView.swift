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
    
    // ID que viene del backend (para QR, etc.)
    var backendId: Int? = nil
}

struct DonationView: View {
    @State private var donaciones: [Donacion] = []
    @State private var mostrarAgregar = false
    @State private var mostrarConfirmacion = false
    @State private var donacionSeleccionada: Donacion? = nil
    
    @State private var ultimaRespuestaBackend: CreateDonationResponse? = nil

    @State private var irADonacionEnviada = false
    @State private var irABasares = false
    @State private var folioActual: String? = nil     // folio que viene del backend
    @State private var mostrarQR = false
    @State private var folioParaQR: String? = nil

    private let azulOscuro = Color(red: 0.0039, green: 0.227, blue: 0.3647)
    private let apiClient = ApiClient()

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
                    .padding(.bottom, 180)
                    .disabled(donaciones.isEmpty)
                }
            }
            // ALERTA de confirmación
            .alert("¿Estás seguro de enviar la donación?", isPresented: $mostrarConfirmacion) {
                Button("Cancelar", role: .cancel) {}
                
                Button("Enviar") {
                    guard let seleccionada = donacionSeleccionada else { return }
                    
                    // Actualizar estado localmente de inmediato
                    if let idx = donaciones.firstIndex(where: { $0.id == seleccionada.id }) {
                        donaciones[idx].estado = "En revisión"
                    }
                    
                    let pesoKg = pesoEnKg(desde: seleccionada.peso)
                    print("Peso calculado en kg: \(pesoKg)")
                    
                    //  Llamada al backend AQUÍ
                    Task {
                        // 1. Payload SIN imágenes
                        let payload = CreateDonationPayload(
                            description: seleccionada.descripcion,
                            weight: pesoKg,
                            category: seleccionada.clasificacion, images:[]
                        )

                        do {
                            // 2. Crear donación en backend
                            let created = try await postDonation(payload: payload)
                            print("Donación creada con id \(created.id)")

                            // 3. Subir imágenes en multipart
                            let imageDatas = seleccionada.imagenes.compactMap { img in
                                img.jpegData(compressionQuality: 0.8)
                            }

                            if !imageDatas.isEmpty {
                                do {
                                    try await apiClient.uploadImages(
                                        donationId: Int(created.id),
                                        images: imageDatas
                                    )
                                    print("Imágenes subidas correctamente")
                                } catch {
                                    print("Error subiendo imágenes:", error)
                                }
                            }

                            // 4. Actualizar UI + navegación
                            await MainActor.run {
                                ultimaRespuestaBackend = created
                                
                                if let idx = donaciones.firstIndex(where: { $0.id == seleccionada.id }) {
                                    donaciones[idx].estado = "En revisión"
                                    donaciones[idx].backendId = Int(created.id)
                                }
                                
                                // guardamos folio como String para el QR
                                folioActual = String(Int(created.id))

                                if pesoKg > 50 {
                                    irADonacionEnviada = true
                                } else {
                                    irABasares = true
                                }
                            }
                        } catch {
                            print("Error enviando donación:", error)
                        }
                    }
                }
            }
            // Navegación a la vista de donación enviada
            .navigationDestination(isPresented: $irADonacionEnviada) {
                if let donacion = donacionSeleccionada {
                    DonationEnviadaView(
                        donacion: donacion,
                        backendDonation: ultimaRespuestaBackend
                    )
                } else {
                    Text("Error: No hay donación seleccionada")
                }
            }
            // Navegación a bazares (con folio real)
            .navigationDestination(isPresented: $irABasares) {
                if let folio = folioActual {
                    BazarListView(folio: folio)
                } else {
                    BazarListView(folio: "0") // fallback por si algo raro pasa
                }
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
            numeroStr.replacingOccurrences(of: ",", with: ".")
        ) ?? 0
        
        // Si viene con unidad, la revisamos
        if partes.count > 1 {
            let unidad = partes[1].lowercased()
            if unidad.contains("g") {
                return valor / 1000.0
            }
        }
        // Si no tiene unidad o es "kg", asumimos kg
        return valor
    }
}

#Preview {
    DonationView()
}
