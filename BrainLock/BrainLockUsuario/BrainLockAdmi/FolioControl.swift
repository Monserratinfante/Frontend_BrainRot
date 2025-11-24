//
//  FolioControl.swift
//  BrainLock
//
//  Created by Fatima Cruz Hernandez on 18/11/25.
//

import SwiftUI

struct Donation: Decodable, Identifiable {
    var id: Int
    var date: Date
}

struct FolioControl: View {
    @State private var donations: [Donation] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ZStack {
                Image("Fondo")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .opacity(0.8)

                Color.black.opacity(0.1).ignoresSafeArea()

                VStack(spacing: 15) {
                    Text("Solicitudes")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.0039, green: 0.227, blue: 0.3647))

                    if isLoading {
                        ProgressView("Cargando...")
                            .padding(.top, 40)

                    } else if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()

                    } else {
                        VStack(spacing: 16) {
                            ForEach(donations) { donation in
                                TarjetaDonation(donation: donation)
                            }
                        }
                    }

                    Spacer()
                }
                .padding(.top, 80)
                .padding(.horizontal)
            }
        }
        .task {
            await loadDonations()
        }
    }

    // MARK: - Load donations
    func loadDonations() async {
        do {
            isLoading = true
            self.donations = try await getDonations()
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = "Error cargando donaciones: \(error.localizedDescription)"
        }
    }
}

struct TarjetaDonation: View {
    var donation: Donation
    @State private var showInfo = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("ID: \(donation.id)")
                        .foregroundColor(.black)
                        .font(.headline)
                        .bold()

                    Text(donation.date.formatted(date: .numeric, time: .omitted))
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }

                Spacer()

                Button {
                    withAnimation(.easeInOut) {
                        showInfo.toggle()
                    }
                } label: {
                    Text("ver más")
                        .font(.footnote)
                        .foregroundColor(Color(red: 0.0, green: 0.6117, blue: 0.651))
                }
            }

            if showInfo {
                Text("Donación registrada el servidor.")
                    .font(.footnote)
                    .foregroundColor(.black)
                    .padding(.top, 8)
                    .transition(.opacity.combined(with: .slide))
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.8)))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.12), lineWidth: 1))
        .shadow(color: .black.opacity(0.35), radius: 8, x: 0, y: 6)
    }
}

func getDonations() async throws -> [Donation] {
    guard let url = URL(string: "/donation/donations", relativeTo: AuthAPI.baseURL) else {
        throw AuthError.invalidURL
    }

    guard let jwt = try? readJWTFromKeychain() else {
        throw AuthError.missingJWT
    }

    var req = URLRequest(url: url)
    req.httpMethod = "POST"
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    req.setValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")

    let (data, response) = try await URLSession.shared.data(for: req)

    guard let httpResponse = response as? HTTPURLResponse,
          200..<300 ~= httpResponse.statusCode else {
        throw AuthError.badStatus((response as? HTTPURLResponse)?.statusCode ?? -1, nil)
    }

    let decoder = JSONDecoder()
    return try decoder.decode([Donation].self, from: data)
}


#Preview {
    FolioControl()
}
