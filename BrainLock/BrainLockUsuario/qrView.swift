//
//  qrView.swift
//  caritas
//
//  Created by Dani on 20/11/25.
//

import SwiftUI

struct QRDonacionView: View {
    
    let folio: String
    
    @State private var qrImage: UIImage? = nil
    @State private var isLoading = true
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // Fondo de pantalla
            Image("Fondo")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            // Capa oscura + degradado
            LinearGradient(
                colors: [
                    Color.black.opacity(0.25),
                    Color.black.opacity(0.35)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 50) {
                Spacer()
                
                // Título superior
                VStack(spacing: 2) {
                    Text("Solicitud enviada")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text("Gracias por tu donativo")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding(.top, 12)
                
                // Tarjeta
                VStack(spacing: 22) {
                    
                    // Folio + etiqueta estado
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("No. Folio")
                                .font(.system(.footnote, design: .rounded))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text("#\(folio)")
                                .font(.system(.title3, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 6) {
                            Circle()
                                .frame(width: 8, height: 8)
                            Text("En revisión")
                                .font(.system(.title3, design: .rounded))
                                .fontWeight(.medium)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            Capsule().fill(Color.white.opacity(0.08))
                        )
                        .foregroundColor(Color(red: 0.631, green: 0.353, blue: 0.584))
                    }
                    
                    // QR desde backend
                    VStack(spacing: 10) {
                        
                        if isLoading {
                            ProgressView("Generando código…")
                                .foregroundColor(.white)
                        }
                        else if let qrImage = qrImage {
                            Image(uiImage: qrImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 210, height: 210)
                                .background(Color.white)
                                .cornerRadius(18)
                                .shadow(radius: 8, y: 4)
                        }
                        else {
                            Text("Error al generar el código QR")
                                .foregroundColor(.red)
                        }
                        
                        Text("Muestra este código en el bazar.")
                            .font(.system(.footnote, design: .rounded))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 8)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top)
                    
                    Divider()
                    
                    // Instrucciones
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Instrucciones")
                            .font(.system(.subheadline, design: .rounded))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Text("Este código debe presentarse en el bazar de su preferencia.")
                            .font(.system(.footnote, design: .rounded))
                            .foregroundColor(.white.opacity(0.85))
                            .multilineTextAlignment(.leading)
                    }
                }
                .padding(22)
                .background(.ultraThinMaterial)
                .cornerRadius(28)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.5), radius: 18, y: 10)
                .padding(.horizontal, 24)
                
                Spacer()
                
                Button("Aceptar") {
                    dismiss()   // solo regresamos una pantalla
                }
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 12)
                .background(Color(red: 0.0, green: 0.61, blue: 0.65))
                .cornerRadius(20)
                .padding(.bottom, 90)
            }
        }
        .task {
            await loadQRCode()
        }
    }
    
    // MARK: - Llamada al backend
    private func loadQRCode() async {
        do {
            let service = QRService()
            let image = try await service.fetchQRCode(donationId: folio)
            qrImage = image
        } catch {
            print("Error cargando QR:", error)
        }
        isLoading = false
    }
}

#Preview {
    QRDonacionView(
        folio: "12345"
    )
}
