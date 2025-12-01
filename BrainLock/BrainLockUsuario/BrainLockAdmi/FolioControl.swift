//
//  FolioControl.swift
//  BrainLock
//
//  Created by Fatima Cruz Hernandez on 18/11/25.
//

import SwiftUI

enum EstadoFolio: String {
    case enRevision = "En revisión"
    case aprobado   = "Aprobado"
    case negado     = "Negado"
    
    var color: Color {
        switch self {
        case .enRevision:
            // #A15A95
            return Color(red: 0.631, green: 0.353, blue: 0.584)
        case .aprobado:
            // #013A5D
            return Color(red: 0.0039, green: 0.2274, blue: 0.3647)
        case .negado:
            // #FF7F32
            return Color(red: 1.0, green: 0.498, blue: 0.196)
        }
    }
}

struct FolioControl: View {
    @State private var folios: [Folio] = [
        Folio(id: UUID(), codigo: "#A7fD9", fecha: "10/02/25", estado: .enRevision, descripcion: "El folio está en revisión por el departamento."),
        Folio(id: UUID(), codigo: "#92AI0", fecha: "27/01/25", estado: .aprobado, descripcion: "Este folio fue aprobado satisfactoriamente."),
        Folio(id: UUID(), codigo: "#85M5D", fecha: "06/12/24", estado: .negado, descripcion: "El folio fue rechazado por falta de documentación.")
    ]
    
    var body: some View {
        NavigationStack{
            ZStack {
                // Fondo imagen
                Image("Fondo")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .opacity(0.8)
                
                Color.black.opacity(0.1)
                    .ignoresSafeArea()
                
                // Contenido principal
                VStack(spacing: 15) {
                    Text("Solicitudes ")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        // #013A5D
                        .foregroundColor(Color(red: 0.0039, green: 0.227, blue: 0.3647))
                    
                    // Cuadros (tarjetas) con navegación y binding
                    VStack(spacing: 16) {
                        ForEach($folios) { $folio in
                            NavigationLink {
                                FolioView(folio: $folio)
                            } label: {
                                TarjetaFolio(
                                    codigo: folio.codigo,
                                    fecha: folio.fecha,
                                    estado: folio.estado,
                                    link: "ver más",
                                    descripcion: folio.descripcion
                                )
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.top,80)
                .padding(.horizontal)
            }
        }
    }
}


struct TarjetaFolio: View {
    var codigo: String
    var fecha: String
    var estado: EstadoFolio
    var link: String
    var descripcion: String
    
    @State private var mostrarInfo = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(codigo)
                        .foregroundColor(.black)
                        .font(.headline)
                        .bold()
                    Text(fecha)
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 6) {
                    Text(estado.rawValue)
                        .font(.subheadline)
                        .foregroundColor(estado.color)
                    
                    Button(action: {
                        withAnimation(.easeInOut) {
                            mostrarInfo.toggle()
                        }
                    }) {
                        Text(link)
                            .font(.footnote)
                            // #009CA6
                            .foregroundColor(Color(red: 0.0, green: 0.6117, blue: 0.651))
                    }
                }
            }
           
            if mostrarInfo {
                Text(descripcion)
                    .font(.footnote)
                    .foregroundColor(.black)
                    .padding(.top, 8)
                    .transition(.opacity.combined(with: .slide))
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.8))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.35), radius: 8, x: 0, y: 6)
    }
}

#Preview {
    FolioControl()
}
