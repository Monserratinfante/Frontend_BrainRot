import UIKit

struct QRRequest: Codable {
    let donationId: String
}

struct QRCodeResponse: Codable {
    let qrCode: String
}

class QRService {
    func fetchQRCode(donationId: String) async throws -> UIImage {
        let baseURL = URL(string: "http://10.14.255.216:3000")!
        guard let url = URL(string: "/donation/qrCode", relativeTo: baseURL) else {
            throw URLError(.badURL)
        }

        // Construir request con JSON en body
        let requestBody = QRRequest(donationId: donationId)
        print("DONATIONID: \(donationId)")
        let jsonData = try JSONEncoder().encode(requestBody)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Ejecutar request
        let (data, _) = try await URLSession.shared.data(for: request)

        // DEBUG: imprimir respuesta cruda
        if let text = String(data: data, encoding: .utf8) {
            print("Respuesta cruda backend:", text)
        }

        // Decodificar **un objeto**, no un array
        let qrResponse = try JSONDecoder().decode(QRCodeResponse.self, from: data)
        // Limpiar base64
        let base64 = qrResponse.qrCode
            .replacingOccurrences(of: "data:image/png;base64,", with: "")
        

        // Convertir a UIImage
        guard let imageData = Data(base64Encoded: base64),
              let uiImage = UIImage(data: imageData) else {
            throw URLError(.cannotDecodeContentData)
        }

        return uiImage
    }
}
