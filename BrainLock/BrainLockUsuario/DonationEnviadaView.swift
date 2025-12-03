import SwiftUI

struct DonationEnviadaView: View {
    let donacion: Donacion
    let backendDonation: CreateDonationResponse?

    private let azulOscuro = Color(red: 0.0039, green: 0.227, blue: 0.3647)
    
    // init con parámetro opcional para no romper otros lados
    init(donacion: Donacion, backendDonation: CreateDonationResponse? = nil) {
        self.donacion = donacion
        self.backendDonation = backendDonation
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
                    
                    // 👇 Ejemplo de uso del backend, opcional
                    if let backendDonation {
                        Text("ID backend: \(Int(backendDonation.id))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .cardStyle()
                
                Spacer()
            }
            .padding()
        }
    }
}

// PREVIEW
#Preview {
    DonationEnviadaView(
        donacion: Donacion(
            foto: nil,
            clasificacion: "Otros",
            descripcion: "termo, platos y toppers",
            peso: "3 kg",
            estado: "Aceptada",
            imagenes: [
                UIImage(named: "termo")!,
                UIImage(named: "platos")!,
                UIImage(named: "toppers")!
            ]
        )
    )
}
