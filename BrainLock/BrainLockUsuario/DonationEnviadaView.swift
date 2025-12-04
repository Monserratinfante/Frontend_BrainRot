import SwiftUI

struct DonationEnviadaView: View {
    let donacion: Donacion
    let backendDonation: CreateDonationResponse?
    let bazar: Bazar?

    private let azulOscuro = Color(red: 0.0039, green: 0.227, blue: 0.3647)
    
    // INIT CORREGIDO
    init(
        donacion: Donacion,
        backendDonation: CreateDonationResponse? = nil,
        bazar: Bazar? = nil
    ) {
        self.donacion = donacion
        self.backendDonation = backendDonation
        self.bazar = bazar
    }
    
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
                
                // CARRUSEL DE FOTOS
                if !donacion.imagenes.isEmpty {
                    TabView {
                        ForEach(donacion.imagenes, id: \.self) { img in
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 280)
                                .cornerRadius(12)
                                .padding(.horizontal, 16)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .onAppear {
                        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.darkGray
                        UIPageControl.appearance().pageIndicatorTintColor = UIColor.gray
                    }
                    .frame(height: 300)
                }
                
                Spacer()

                VStack(spacing: 6) {
                    Text("Clasificación: \(donacion.clasificacion)")
                        .foregroundStyle(azulOscuro)
                    
                    Text("Descripción: \(donacion.descripcion)")
                        .foregroundStyle(azulOscuro)
                    
                    Text("Peso: \(donacion.peso)")
                        .foregroundStyle(azulOscuro)
                    
                    Text("Estado: \(donacion.estado ?? "En revisión")")
                        .foregroundColor(.green)
                        .bold()
                    
                    // Mostrar el bazar si existe
                    if let bazar {
                        Text("Bazar seleccionado:")
                            .foregroundStyle(azulOscuro)
                            .bold()
                            .padding(.top, 4)
                        
                        Text(bazar.name)
                            .foregroundStyle(azulOscuro)
                        
                        Text(bazar.address)
                            .foregroundStyle(.gray)
                    }
                    
                    // Datos del backend (folio)
                    if let backendDonation {
                        Text("Folio: \(Int(backendDonation.id))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .cardStyle()
                .padding(.bottom, 16)
                
                // Botón para ver QR
                if let backendDonation {
                    NavigationLink {
                        QRDonacionView(folio: String(Int(backendDonation.id)))
                    } label: {
                        HStack {
                            Image(systemName: "qrcode")
                            Text("Ver código QR")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(red: 0.0, green: 0.61, blue: 0.65))
                        )
                        .shadow(radius: 6, y: 4)
                    }
                    .padding(.bottom, 24)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

