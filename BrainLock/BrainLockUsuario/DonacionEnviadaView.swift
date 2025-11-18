//
//  DonacionEnviada.swift
//  BrainLock
//
//  Created by Alumno on 07/11/25.
//

import SwiftUI

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
