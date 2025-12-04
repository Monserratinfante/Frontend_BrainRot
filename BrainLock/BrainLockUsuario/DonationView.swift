//
//  DonationView.swift (Optimizado)
//

import SwiftUI

struct Donacion: Identifiable {
    let id = UUID()
    var foto: Image? = nil
    var clasificacion: String
    var descripcion: String
    var peso: String
    var estado: String? = nil
    var imagenes: [UIImage] = []
    var backendId: Int? = nil
    var bazarNombre: String? = nil
}

struct DonationView: View {
    // MARK: - Estados globales del flujo
    @State private var donaciones: [Donacion] = []
    @State private var mostrarAgregar = false
    @State private var mostrarConfirmacion = false
    
    @State private var donacionSeleccionada: Donacion? = nil
    @State private var ultimaRespuestaBackend: CreateDonationResponse? = nil
    @State private var bazarSeleccionado: Bazar? = nil
    
    @State private var irADetalle = false
    @State private var irABazares = false
    @State private var irAQR = false
    @State private var folioActual: String? = nil
    
    private let azulOscuro = Color(red: 0.0039, green: 0.227, blue: 0.3647)
    private let apiClient = ApiClient()
    
    var body: some View {
        NavigationStack {
            ZStack {
                fondo
                contenido
            }
        }
        .navigationDestination(isPresented: $irADetalle) {
            DonationDetailDestination
        }
        .navigationDestination(isPresented: $irABazares) {
            BazarListDestination
        }
        .navigationDestination(isPresented: $irAQR) {
            QRDestination
        }
        .alert("¿Estás seguro de enviar la donación?", isPresented: $mostrarConfirmacion) {
            Button("Cancelar", role: .cancel) { }
            Button("Enviar") { enviarDonacion() }
        }
        .fullScreenCover(isPresented: $mostrarAgregar) {
            AgregarDonacionView { nueva in
                donaciones.append(nueva)
            }
        }
    }
}

// MARK: - Fondo
extension DonationView {
    var fondo: some View {
        ZStack {
            azulOscuro.ignoresSafeArea()
            Image("Fondo")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
    }
}


// MARK: - Contenido principal
extension DonationView {
    var contenido: some View {
        VStack {
            BaseHeader(title: "Donaciones")
            BotonAgregar
            ListaDonaciones
            BotonEnviar
        }
    }
}
extension DonationView {
    var BotonAgregar: some View {
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
                RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.18), lineWidth: 1)
            )
            .padding(.horizontal, 20)
        }
        .buttonStyle(.plain)
    }
}

struct DonacionRow: View {
    let item: Donacion
    let onTap: () -> Void
    
    var body: some View {
        Button { onTap() } label: {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.clasificacion).font(.headline).foregroundColor(.black)
                    Text(item.descripcion).foregroundColor(.black).lineLimit(2)
                    Text("Peso: \(item.peso)").foregroundColor(.black)
                    
                    if let estado = item.estado {
                        Text("Estado: \(estado)")
                            .foregroundColor(.green)
                            .fontWeight(.semibold)
                    }
                }
                
                Spacer()
                
                DonacionImagen(item: item)
            }
            .padding(14)
            .background(Color.white.opacity(0.85))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(.gray.opacity(0.4), lineWidth: 1))
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.08), radius: 4)
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 20)
    }
}

struct DonacionImagen: View {
    let item: Donacion
    
    var body: some View {
        Group {
            if let foto = item.foto {
                foto.resizable().scaledToFit()
            } else if let primera = item.imagenes.first {
                Image(uiImage: primera)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "shippingbox.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 70, height: 70)
        .clipped()
        .cornerRadius(6)
    }
}

extension DonationView {
    var BotonEnviar: some View {
        Button {
            if let ultima = donaciones.last {
                donacionSeleccionada = ultima
                mostrarConfirmacion = true
            }
        } label: {
            Text("Enviar donación")
                .font(.headline).bold()
                .foregroundColor(azulOscuro)
                .padding(.vertical, 14)
                .padding(.horizontal, 18)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(donaciones.isEmpty ? .white : Color(red: 0.00, green: 0.55, blue: 0.60))
                )
                .shadow(color: .black.opacity(0.4), radius: 8)
        }
        .padding(.bottom, 180)
        .disabled(donaciones.isEmpty)
    }
}

extension DonationView {
    var DonationDetailDestination: some View {
        Group {
            if let donacion = donacionSeleccionada {
                AnyView(
                    DonationEnviadaView(
                        donacion: donacion,
                        backendDonation: ultimaRespuestaBackend,
                        bazar: bazarSeleccionado
                    )
                )
            } else {
                AnyView(Text("No se encontró la donación."))
            }
        }
    }

    
    var BazarListDestination: some View {
        BazarListView(
            folio: folioActual ?? "0",
            onBazarSelected: { bazar in
                bazarSeleccionado = bazar

                // Guardar nombre dentro de la donación seleccionada
                if let seleccionada = donacionSeleccionada,
                   let idx = donaciones.firstIndex(where: { $0.id == seleccionada.id }) {
                    donaciones[idx].bazarNombre = bazar.name
                }

                // Una vez seleccionado, navegar al detalle de la donación
                irABazares = false
                irADetalle = true
            }
        )
    }
    
    var QRDestination: some View {
        QRDonacionView(folio: folioActual ?? "0")
    }
}

extension DonationView {
    private func enviarDonacion() {
        guard let seleccionada = donacionSeleccionada else { return }

        // Actualizar estado local
        if let idx = donaciones.firstIndex(where: { $0.id == seleccionada.id }) {
            donaciones[idx].estado = "En revisión"
        }

        let pesoKg = pesoEnKg(desde: seleccionada.peso)

        Task {
            do {
                let payload = CreateDonationPayload(
                    description: seleccionada.descripcion,
                    weight: pesoKg,
                    category: seleccionada.clasificacion,
                    images: []
                )

                let created = try await postDonation(payload: payload)

                let imageDatas = seleccionada.imagenes.compactMap {
                    $0.jpegData(compressionQuality: 0.8)
                }

                if !imageDatas.isEmpty {
                    try? await apiClient.uploadImages(
                        donationId: Int(created.id),
                        images: imageDatas
                    )
                }

                await MainActor.run {
                    ultimaRespuestaBackend = created
                    folioActual = "\(created.id)"

                    if pesoKg > 50 {
                        irAQR = true
                    } else {
                        irABazares = true
                    }
                }

            } catch {
                print("Error enviando:", error)
            }
        }
    }

    private func pesoEnKg(desde texto: String) -> Double {
        let partes = texto.split(separator: " ")
        guard let n = partes.first else { return 0 }
        let valor = Double(n.replacingOccurrences(of: ",", with: ".")) ?? 0
        
        if partes.count > 1, partes[1].lowercased().contains("g") {
            return valor / 1000
        }
        return valor
    }
}

// MARK: - Lista de Donaciones
extension DonationView {
    var ListaDonaciones: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(donaciones) { item in
                    DonacionRow(item: item) {
                        donacionSeleccionada = item
                        irADetalle = true
                    }
                }
                
                if donaciones.isEmpty {
                    Text("Aún no has agregado donaciones.")
                        .foregroundColor(.black.opacity(0.8))
                        .padding(.top, 40)
                }
            }
            .padding(.top, 8)
        }
    }
}


