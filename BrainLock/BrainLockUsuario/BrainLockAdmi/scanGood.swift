//
//  scanGood.swift
//

import SwiftUI

struct scanGood: View {
    @Environment(\.dismiss) var dismiss
    @Binding var showSuccess: Bool

    var body: some View {
        ScannerView { code in
            print("Código escaneado:", code)

            Task {
                do {
                    guard let id = extractDonationId(from: code) else {
                        print("QR inválido")
                        return
                    }

                    try await markDonationAsDelivered(donationId: id)

                    // Mostrar alerta al cerrar
                    showSuccess = true
                    dismiss()

                } catch {
                    print("ERROR:", error)
                }
            }
        }
        .ignoresSafeArea()
    }

    func extractDonationId(from code: String) -> String? {
        guard let data = code.data(using: .utf8) else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return nil }
        return json["donationId"] as? String
    }
}

#Preview {
    scanGood(showSuccess: .constant(false))
}
