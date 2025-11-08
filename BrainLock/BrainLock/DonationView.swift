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
    var peso: String
    var estado: String? = nil // "En revisión", "Aceptada", "Cancelada"
}

struct DonationsView: View {
    @State private var donaciones: [Donacion] = [] // Lista vacía por defecto
    @State private var mostrarAgregar = false
    @State private var mostrarConfirmacion = false
    @State private var donacionSeleccionada: Donacion? = nil
    @State private var irADonacionEnviada = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Fondo con imagen + negro opaco
                Image("Colores")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                Color.gray.opacity(0.85)
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    BaseHeader(title: "Donaciones")
                    
                    // Botón de agregar donación arriba
                    Button {
                        mostrarAgregar = true
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                            Text("Agregar productos")
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
                                .stroke(Color.gray.opacity(0.18), lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                    }
                    .buttonStyle(.plain)
                    
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(donaciones) { item in
                                HStack(alignment: .center) {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(item.clasificacion).font(.headline).foregroundColor(.white)
                                        Text(item.descripcion).foregroundColor(.white)
                                        Text("Peso: \(item.peso)").foregroundColor(.white)
                                        if let estado = item.estado {
                                            Text("Estado: \(estado)").foregroundColor(.green)
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
                            }
                        }
                    }
                    
                    // Botón “Enviar donación” abajo
                    Button {
                        guard !donaciones.isEmpty else { return } // evita crash si está vacío
                        donacionSeleccionada = donaciones.last
                        mostrarConfirmacion = true
                    } label: {
                        Text("Enviar donación")
                            .multilineTextAlignment(.center)
                            .font(.headline).bold()
                            .foregroundColor(.white)
                            .padding(.vertical, 14)
                            .padding(.horizontal, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(donaciones.isEmpty ? Color.gray : Color(red: 0.00, green: 0.55, blue: 0.60))
                            )
                            .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 6)
                    }
                    .padding(.bottom, 26)
                    .disabled(donaciones.isEmpty) // Desactiva si no hay donaciones
                }
            }
            // Sheet para agregar nueva donación
            .sheet(isPresented: $mostrarAgregar) {
                AgregarDonacionView { nuevaDonacion in
                    donaciones.append(nuevaDonacion)
                    mostrarAgregar = false
                }
            }
            // Alerta de confirmación de envío
            .alert("¿Estás seguro de enviar la donación?", isPresented: $mostrarConfirmacion) {
                Button("Cancelar", role: .cancel) { }
                Button("Enviar") {
                    if let index = donaciones.firstIndex(where: { $0.id == donacionSeleccionada?.id }) {
                        donaciones[index].estado = "En revisión"
                        irADonacionEnviada = true
                    }
                }
            }
            // Navegación a la vista de donación enviada, si no la uso se caga todo 
            .navigationDestination(isPresented: $irADonacionEnviada) {
                if let donacion = donacionSeleccionada {
                    DonacionEnviadaView(donacion: donacion)
                } else {
                    Text("Error: No hay donación seleccionada")
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct DonacionEnviadaView: View {
    let donacion: Donacion
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Donación enviada")
                .font(.title)
                .bold()
            
            if let foto = donacion.foto {
                foto
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
            } else {
                Image(systemName: "shippingbox.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            }
            
            Text("Clasificación: \(donacion.clasificacion)")
            Text("Descripción: \(donacion.descripcion)")
            Text("Peso: \(donacion.peso)")
            Text("Estado: \(donacion.estado ?? "En revisión")")
                .foregroundColor(.green)
                .bold()
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    DonationsView()
}
