//
//  DonationEnviadaView.swift
//  BrainLock
//
//  Created by Fatima Cruz Hernandez on 18/11/25.
//

import SwiftUI

struct DonacionEnviadaView: View {
    let donacion: Donacion
    private let azulOscuro = Color(red: 0.0039, green: 0.227, blue: 0.3647)
    
    var body: some View {
        ZStack {

            // Fondo
            Image("Fondo")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Donación enviada")
                    .font(.title)
                    .bold()
                    .foregroundStyle(azulOscuro)
                    .padding(20)
                
                if let foto = donacion.foto {
                    foto
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                } else {
                    Image(systemName: "shippingbox.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.black)
                }
                Spacer()

                VStack{
                    Text("Clasificación: \(donacion.clasificacion)")
                        .foregroundStyle(azulOscuro)
                    
                    Text("Descripción: \(donacion.descripcion)")
                        .foregroundStyle(azulOscuro)
                    
                    Text("Peso: \(donacion.peso)")
                        .foregroundStyle(azulOscuro)
                    Text("Estado: \(donacion.estado ?? "En revisión")")
                        .foregroundColor(.green)
                        .bold()
                 
                }
                .cardStyle()
                Spacer()

            }
            .padding()
        }
    }
}



#Preview {
    DonacionEnviadaView(
        donacion: Donacion(
            foto: Image(uiImage: UIImage(named: "termo")!), // CUALQUIER ASSET
            clasificacion: "Ropa",
            descripcion: "Tenis en buen estado",
            peso: "2 kg",
            estado: "Aceptada"
        )
    )
}

