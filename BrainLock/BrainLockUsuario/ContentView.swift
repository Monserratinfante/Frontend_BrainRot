//
//  ContentView.swift
//  BrainLock
//

import SwiftUI

struct ContentView: View {
    // Estado de splash/animación
    @State private var isLoading = true
    @State private var scale: CGFloat = 1.0
    
    @AppStorage("loggedRole") private var loggedRole: String = ""

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            if isLoading {
                ZStack {
                    Image("Portada3")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()

                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .offset(y: -100)
                        .scaleEffect(scale)
                        .onAppear {
                            // Animación de pulso infinito
                            withAnimation(.easeInOut(duration: 5.0).repeatForever(autoreverses: true)) {
                                scale = 2.05
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                                withAnimation(.easeInOut) {
                                    isLoading = false
                                }
                            }
                        }
                }
            }  else {
                // Root decision                
                if loggedRole.isEmpty {
                    VistaInicio()        // Shows login/register buttons
                } else if loggedRole == "USER" {
                    DonationView()
                } else if loggedRole == "ADMIN" {
                    FolioControl()
                }
            }
        }
    }
}

func validateSession() async throws -> Roles {
    guard let url = URL(string: "/authorization/validate", relativeTo: AuthAPI.baseURL) else {
        throw AuthError.invalidURL
    }

    guard let jwt = try? readJWTFromKeychain() else {
        throw AuthError.missingJWT
    }

    var req = URLRequest(url: url)
    req.httpMethod = "GET"
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    req.setValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")

    let (data, response) = try await URLSession.shared.data(for: req)
    guard let httpResponse = response as? HTTPURLResponse,
          200..<300 ~= httpResponse.statusCode else {
        throw AuthError.badStatus((response as? HTTPURLResponse)?.statusCode ?? -1, nil)
    }
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return try decoder.decode(Roles.self, from: data)
}

#Preview {
    ContentView()
}
