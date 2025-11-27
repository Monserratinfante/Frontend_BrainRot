//
//  BasarMapTemplate.swift
//  BrainLock
//
//  Created by alumno on 26/11/25.
//

import SwiftUI
import MapKit


// MARK: - Modelo de bazar

struct Bazar: Identifiable {
    let id: Int
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }
}

// MARK: - Datos estáticos de bazares

enum BazarData {
    static let all: [Bazar] = [
        Bazar(
            id: 1,
            name: "Monte Cristal 1",
            address: "Ave. Monte Cristal 141\nCol. Monte Cristal 1er Sector\nJuárez, N.L.",
            latitude: 25.65055,
            longitude: -100.11140
        ),
        Bazar(
            id: 2,
            name: "San Marcos - Villas Santo Domingo",
            address: "Av. Diego Díaz de Berlanga 172\nCol. San Marcos / Villas Santo Domingo\nSan Nicolás de los Garza, N.L.",
            latitude: 25.6750,
            longitude: -100.0900
        ),
        Bazar(
            id: 3,
            name: "Buena Vista Carmen",
            address: "Av. Vista Regia 580\nCol. Buena Vista\nEl Carmen, N.L.",
            latitude: 25.7770,
            longitude: -100.1050
        ),
        Bazar(
            id: 4,
            name: "Centrito del Valle",
            address: "Río Mississippi 44\nCol. Del Valle\nSan Pedro Garza García, N.L.",
            latitude: 25.6751,
            longitude: -100.3139
        ),
        Bazar(
            id: 5,
            name: "Tres Caminos Guadalupe",
            address: "1a Privada 901\nCol. Tres Caminos Norte\nGuadalupe, N.L.",
            latitude: 25.7280,
            longitude: -100.3070
        ),
        Bazar(
            id: 6,
            name: "Las Avenidas Guadalupe",
            address: "Av. Eloy Cavazos 4301\nCol. Residencial Las Avenidas\nGuadalupe, N.L.",
            latitude: 25.6950,
            longitude: -100.2650
        ),
        Bazar(
            id: 7,
            name: "Infonavit La Huasteca",
            address: "Calle Cada del Obrerón 317\nCol. Infonavit La Huasteca\nSanta Catarina, N.L.",
            latitude: 25.6420,
            longitude: -100.3440
        ),
        Bazar(
            id: 8,
            name: "Praderas de Girasoles Escobedo",
            address: "Paseo de la Amistad 542\nCol. Praderas de Girasoles\nEscobedo, N.L.",
            latitude: 25.7500,
            longitude: -100.2000
        ),
        Bazar(
            id: 9,
            name: "Concordia",
            address: "Fresno 610\nCol. Prados de Santa Rosa\nApodaca, N.L.\nTel. 81 42 85 12 59",
            latitude: 25.7830,
            longitude: -100.1760
        ),
        Bazar(
            id: 10,
            name: "Bernardo Reyes",
            address: "Bernardo Reyes 5656\nCol. Ferrocarrilera, C.P. 64250\nMonterrey, N.L.\nTel. 81 1357 3308",
            latitude: 25.7150,
            longitude: -100.3390
        ),
        Bazar(
            id: 11,
            name: "Acapulco",
            address: "Blvd. Acapulco 415 Local 2 y 3\nFracc. Balcones de San Miguel\nGuadalupe, N.L.\nTel. 81 41 97 33 59",
            latitude: 25.6820,
            longitude: -100.2410
        ),
        Bazar(
            id: 12,
            name: "San Gilberto",
            address: "Ave. Perimetral Norte 512\nCol. San Gilberto, C.P. 66369\nSanta Catarina, N.L.\nTel. 81 1338 4036",
            latitude: 25.6750,
            longitude: -100.4930
        ),
        Bazar(
            id: 13,
            name: "Guadalupe",
            address: "Ignacio Zaragoza 233\nCruz con Morelos, Centro\nC.P. 67100\nGuadalupe, N.L.\nTel. 81 8191 1950",
            latitude: 25.6760,
            longitude: -100.2570
        ),
        Bazar(
            id: 14,
            name: "San Nicolás",
            address: "Escobedo 144 Pte.\nCruz con Treviño, Zona Centro\nC.P. 66400\nSan Nicolás de los Garza, N.L.\nTel. 81 8007 4580",
            latitude: 25.7410,
            longitude: -100.3020
        ),
        Bazar(
            id: 15,
            name: "Escobedo",
            address: "Ave. Benito Juárez 184-A\nCol. Residencial Escobedo\nC.P. 66057\nEscobedo, N.L.\nTel. 81 8058 3163",
            latitude: 25.7990,
            longitude: -100.3180
        ),
        Bazar(
            id: 16,
            name: "Chula Vista",
            address: "Carretera a Reynosa (Ave. Benito Juárez) 225\nCol. Chula Vista, C.P. 67188\nGuadalupe, N.L.\nTel. 81 1093 7461",
            latitude: 25.6840,
            longitude: -100.1870
        ),
        Bazar(
            id: 17,
            name: "Arteaga",
            address: "Emilio Carranza 839 Ote\nCentro, C.P. 64000\nEntre Arteaga y Carlos Salazar\nMonterrey, N.L.\nTel. 81 83 74 92 80",
            latitude: 25.6735,
            longitude: -100.3070
        ),
        Bazar(
            id: 18,
            name: "Cumbres",
            address: "Enrique C. Livas 108\nCumbres 1er Sector\nC.P. 64349\nMonterrey, N.L.\nTel. 81 8123 3576",
            latitude: 25.7320,
            longitude: -100.3730
        ),
        Bazar(
            id: 19,
            name: "Alameda",
            address: "Aramberri 913 Pte (Frente a Alameda)\nCol. Centro, C.P. 64000\nMonterrey, N.L.\nTel. 81 83 42 76 80",
            latitude: 25.6728,
            longitude: -100.3130
        ),
        Bazar(
            id: 20,
            name: "Fama",
            address: "Manuel J. Clouthier 201, Local 3\nCol. Fama, C.P. 66100\nSanta Catarina, N.L.\nTel. 81 83 15 80 50",
            latitude: 25.6670,
            longitude: -100.4500
        ),
        Bazar(
            id: 21,
            name: "Divina",
            address: "Florencio Antillón 1223\nCol. Centro, C.P. 64720\nMonterrey, N.L.\nTel. 81 83 40 40 77",
            latitude: 25.6691,
            longitude: -100.3019
        ),
        Bazar(
            id: 22,
            name: "San Rafael",
            address: "Ave. San Rafael 90, Bodega 8\nCol. Ángel Martínez Villarreal\nGuadalupe, N.L., C.P. 67110\nTel. 811 159 2629",
            latitude: 25.6845,
            longitude: -100.2290
        ),
        Bazar(
            id: 23,
            name: "Solidaridad",
            address: "Criminólogos 601 Lote 22\nCol. Trazo Marco, C.P. 64103\nMonterrey, N.L.\nTel. 81 27 04 38 70",
            latitude: 25.7500,
            longitude: -100.3050
        )
    ]
}

// MARK: - Vista de mapa

struct BazarMapView: View {
    @Environment(\.dismiss) var dismiss
    let bazar: Bazar

    private let azulOscuro = Color(red: 0.0039, green: 0.227, blue: 0.3647)

    var body: some View {
        ZStack {
            // Fondo
            Image("Colores")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack(spacing: 20) {
                Spacer()
                // Título
                VStack(spacing: 14) {
                    Text("Bazar Cáritas")
                        .font(.title2.bold())
                        .foregroundColor(azulOscuro)
                        .tracking(1.5)

                    Text(bazar.name)
                        .font(.title.bold())
                        .foregroundColor(azulOscuro)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 12)

                // Mapa en tarjeta de “glass”
                Map(initialPosition: .region(bazar.region)) {
                    Marker(bazar.name, coordinate: bazar.coordinate)
                    Annotation(bazar.name, coordinate: bazar.coordinate) {
                        Image(systemName: "mappin.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .background(.white)
                            .clipShape(Circle())
                    }
                }
                .frame(height: 260)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(.ultraThinMaterial)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.white.opacity(0.3), lineWidth: 0.8)
                )
                .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 8)

                // Tarjeta de info
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.title3)
                            .foregroundColor(azulOscuro)

                        Text(bazar.address)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }

                    Divider().opacity(0.4)

                    HStack(spacing: 8) {
                        Image(systemName: "info.circle")
                            .font(.subheadline)
                            .foregroundColor(azulOscuro)

                        Text("Revisa horarios y disponibilidad directamente en el bazar.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.white.opacity(0.35), lineWidth: 0.8)
                )
                .shadow(color: .black.opacity(0.18), radius: 8, x: 0, y: 6)

                Spacer()
            }
            .padding(.horizontal, 20)
            Spacer()
            .padding(.bottom, 24)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold))

                        Text("Donaciones")
                            .font(.system(size: 18, weight: .bold))
                    }
                    .foregroundColor(azulOscuro)
                }
            }
        }
    }
}

// MARK: - Lista de bazares

struct BazarListView: View {
    private let azulOscuro = Color(red: 0.0039, green: 0.227, blue: 0.3647)

    var body: some View {
        NavigationStack {
            ZStack {
                // Fondo de la vista
                Image("Colores")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(alignment: .center, spacing: 16) {

                    // Título
                    Text("Bazares")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(azulOscuro)
                        .padding(.top, 70)
                        .padding(.horizontal)

                    Text("Selecciona el bazar más cercano para llevar tu donación.")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(azulOscuro.opacity(0.8))
                        .padding(.horizontal)
                        .padding(.bottom, 4)

                    // Lista de bazares
                    List {
                        ForEach(BazarData.all) { bazar in
                            NavigationLink {
                                BazarMapView(bazar: bazar)
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(bazar.name)
                                            .font(.headline)
                                            .foregroundColor(azulOscuro)

                                        Text(bazar.address.components(separatedBy: "\n").first ?? "")
                                            .font(.subheadline)
                                            .foregroundColor(.black.opacity(0.7))
                                    }

                                    Spacer()

                                }
                                .padding(16)
                                .background(
                                    // Liquid Glass Card
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.ultraThinMaterial)
                                        .background(
                                            Color.white.opacity(0.05)
                                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.white.opacity(0.18), lineWidth: 1)
                                        )
                                        .shadow(color: .black.opacity(0.30), radius: 10, x: 0, y: 6)
                                )
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        BazarListView()
    }
}
