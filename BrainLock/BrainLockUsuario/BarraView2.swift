//
//  BarraView.swift
//  caritas
//
//  Created by GP  on 12/11/25.
//

import SwiftUI
import MapKit

struct BarraView2: View {
    var body: some View {
        TabView {
            DonationView()
                .tabItem { Label("Donaciones", systemImage: "heart.fill") }

            BazarListViewSimple()
                .tabItem { Label("Bazares", systemImage: "location") }

            UsuarioPerfil()
                .tabItem { Label("Perfil", systemImage: "person.circle") }
        }
    }
}

// MARK: - Lista simple de bazares para TabView
struct BazarListViewSimple: View {
    let bazares: [Bazar] = BazarData.all
    private let azulOscuro = Color(red: 0.0039, green: 0.227, blue: 0.3647)

    var body: some View {
        NavigationStack {
            ZStack {
                Image("Colores")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(bazares) { bazar in
                            NavigationLink {
                                BazarMapViewSimple(bazar: bazar)
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .fill(.ultraThinMaterial)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                                .stroke(Color.white.opacity(0.22), lineWidth: 1)
                                        )
                                        .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 6)

                                    HStack(spacing: 14) {
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text(bazar.name)
                                                .font(.headline)
                                                .foregroundColor(.white)

                                            Text(bazar.address)
                                                .font(.footnote)
                                                .foregroundColor(.white.opacity(0.8))
                                                .lineLimit(2)
                                        }

                                        Spacer()

                                        Image(systemName: "chevron.right.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(.white.opacity(0.9))
                                    }
                                    .padding(.horizontal, 18)
                                    .padding(.vertical, 14)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Bazares Cáritas")
        }
    }
}

// MARK: - Mapa simple de bazar
struct BazarMapViewSimple: View {
    let bazar: Bazar
    private let azulOscuro = Color(red: 0.0039, green: 0.227, blue: 0.3647)

    var body: some View {
        ZStack {
            Image("Colores")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

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

                Map(initialPosition: .region(MKCoordinateRegion(
                    center: bazar.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                ))) {
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
                .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 8)

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
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
