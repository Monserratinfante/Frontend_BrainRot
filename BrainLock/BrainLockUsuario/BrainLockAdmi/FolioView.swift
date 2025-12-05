//
//  FolioView.swift
//  BrainLock
//

import SwiftUI

struct User: Decodable {
    var email: String
    var username: String?
}

struct SingleDonation: Decodable {
    var id: Int
    var createdAt: Date
    var user: User
    var description: String
    var category: String
    var weight: Double
    var images: [String]
}

struct UpdateStatusPayload: Encodable {
    var donationId: String
    var donationStatus: String
}

extension String: @retroactive Identifiable {
    public var id: String { self }
}

struct FolioView: View {
    @Environment(\.dismiss) var dismiss
    var id: Int
    var onStatusUpdated: (() -> Void)? = nil
    
    @State private var donation: SingleDonation? = nil
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var mostrarConfirmacion = false
    @State private var accionPendiente: EstadoAccion? = nil
    @State private var selectedImageURL: String? = nil
    
    enum EstadoAccion {
        case aprobado
        case rechazado
    }
    
    var body: some View {
        ZStack {
            Image("Fondo")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .opacity(0.15)
            
            ScrollView {
                if isLoading {
                    ProgressView("Cargando...")
                        .padding(.top, 90)
                    
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 90)
                    
                } else if let donation = donation {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        // Encabezado
                        HStack {
                            Text("Folio \(donation.id)")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        
                        // Datos donación
                        VStack(alignment: .leading, spacing: 12) {
                            
                            Group {
                                HStack {
                                    Image(systemName: "calendar")
                                    Text("Fecha: \(donation.createdAt.formatted(date: .numeric, time: .shortened))")
                                }
                                
                                HStack {
                                    Image(systemName: "tag")
                                    Text("Categoría: \(donation.category)")
                                }
                                
                                HStack {
                                    Image(systemName: "scalemass")
                                    Text("Peso: \(donation.weight) kg")
                                }
                            }
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            
                            Divider()
                            
                            // Usuario
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Usuario")
                                    .font(.headline)
                                
                                HStack {
                                    Image(systemName: "envelope")
                                    Text(donation.user.email)
                                }
                                
                                if let username = donation.user.username {
                                    HStack {
                                        Image(systemName: "person")
                                        Text(username)
                                    }
                                }
                            }
                            .font(.body)
                            .foregroundStyle(.primary)
                            
                            Divider()
                            
                            // Descripción
                            Text("Descripción")
                                .font(.headline)
                            
                            Text(donation.description)
                                .font(.body)
                                .foregroundStyle(.primary)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Divider()
                            
                            Text("Imágenes")
                                .font(.headline)
                            
                            Images(donation.images)
                        }
                        .padding()
                        .background(.white.opacity(0.9))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.black.opacity(0.08), lineWidth: 1)
                        )
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
                        
                        // Botones
                        VStack(spacing: 12) {
                            Button {
                                accionPendiente = .aprobado
                                mostrarConfirmacion = true
                            } label: {
                                Text("Autorizar")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            
                            Button {
                                accionPendiente = .rechazado
                                mostrarConfirmacion = true
                            } label: {
                                Text("Rechazar")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                        .padding(.top, 6)
                    }
                    .padding()
                }
            }.padding(.top, 70)
        }
        .navigationTitle("Detalle del folio")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadDonation()
        }
        .sheet(item: $selectedImageURL) { url in
            ImageViewer(urlString: url)
        }
        .alert("Confirmar acción", isPresented: $mostrarConfirmacion) {
            Button("Confirmar", role: .destructive) {
                Task {
                    await ejecutarAccion()
                }
            }
            Button("Cancelar", role: .cancel) { }
        } message: {
            Text(accionPendiente == .aprobado
                 ? "¿Deseas autorizar esta donación?"
                 : "¿Deseas rechazar esta donación?")
        }
    }
    
    func Images(_ images: [String]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(images, id: \.self) { urlString in
                    if let url = URL(string: urlString) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 120, height: 120)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipped()
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        selectedImageURL = urlString
                                    }
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 120)
                                    .foregroundColor(.gray)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                }
            }
        }
        .frame(height: 140)
    }

    
    func loadDonation() async {
        do {
            guard let url = URL(string: "/donation/singleDonation/\(id)", relativeTo: AuthAPI.baseURL) else {
                throw AuthError.invalidURL
            }
            
            guard let jwt = try? readJWTFromKeychain() else {
                throw AuthError.missingJWT
            }
            
            var req = URLRequest(url: url)
            req.httpMethod = "GET"
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            req.setValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")
            
            let (data, response) = try await URLSession.shared.data(for: req)
            
            guard let http = response as? HTTPURLResponse,
                  200..<300 ~= http.statusCode else {
                throw AuthError.badStatus((response as? HTTPURLResponse)?.statusCode ?? -1, nil)
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            self.donation = try decoder.decode(SingleDonation.self, from: data)
            self.errorMessage = nil
            self.isLoading = false
            
        } catch {
            self.errorMessage = "Error cargando donación: \(error.localizedDescription)"
            self.isLoading = false
        }
    }
    
    func ejecutarAccion() async {
        guard let accion = accionPendiente else { return }
        
        let status = accion == .aprobado ? "AUTHORIZED" : "REJECTED"
        
        do {
            guard let url = URL(string: "/donation/updateStatus", relativeTo: AuthAPI.baseURL) else {
                throw AuthError.invalidURL
            }
            
            guard let jwt = try? readJWTFromKeychain() else {
                throw AuthError.missingJWT
            }
            
            var req = URLRequest(url: url)
            req.httpMethod = "PUT"
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            req.setValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")
            req.httpBody = try JSONEncoder().encode(
                UpdateStatusPayload(donationId: String(id), donationStatus: status)
            )
            
            let (_, response) = try await URLSession.shared.data(for: req)
            
            guard let http = response as? HTTPURLResponse,
                  200..<300 ~= http.statusCode else {
                throw AuthError.badStatus((response as? HTTPURLResponse)?.statusCode ?? -1, nil)
            }
            
            // Update local UI
            self.accionPendiente = accion
            
            // Notify parent list to refresh
            onStatusUpdated?()
            
            // Show success alert
            errorMessage = "Estado actualizado correctamente"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                dismiss()
            }
        } catch {
            errorMessage = "Error realizando acción: \(error.localizedDescription)"
        }
    }
}

struct ImageViewer: View {
    let urlString: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Group {
            if let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .onTapGesture { dismiss() }
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "exclamationmark.triangle")
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

