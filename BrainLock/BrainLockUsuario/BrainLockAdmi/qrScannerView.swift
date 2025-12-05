import UIKit
import AVFoundation

class ScannerViewController: UIViewController {

    let session = AVCaptureSession()
    var onCodeScanned: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }

    func setupCamera() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }

        do {
            let input = try AVCaptureDeviceInput(device: device)
            let output = AVCaptureMetadataOutput()

            session.beginConfiguration()
            if session.canAddInput(input) { session.addInput(input) }
            if session.canAddOutput(output) {
                session.addOutput(output)
                output.setMetadataObjectsDelegate(self, queue: .main)
                output.metadataObjectTypes = [.qr]
            }
            session.commitConfiguration()

            let preview = AVCaptureVideoPreviewLayer(session: session)
            preview.videoGravity = .resizeAspectFill
            preview.frame = view.bounds
            view.layer.addSublayer(preview)

            DispatchQueue.global(qos: .userInitiated).async {
                self.session.startRunning()
            }

        } catch {
            print("Camera error:", error)
        }
    }
}

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        
        guard let metadata = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              metadata.type == .qr,
              let value = metadata.stringValue else { return }

        session.stopRunning()

        DispatchQueue.main.async {

            self.onCodeScanned?(value)
        }
    }
}


func markDonationAsDelivered(donationId: String) async throws {
        let baseURL = URL(string: "http://10.14.255.216:3000")!

        // URL de tu endpoint
        guard let url = URL(string: "/donation/delivery/\(donationId)", relativeTo: baseURL) else {
            throw URLError(.badURL)
        }
        print("URl->", url)
    
        guard let token = try readJWTFromKeychain() else {
            throw AuthError.badStatus(401, "No token stored in Keychain")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // Cuerpo JSON (si tu endpoint espera donationId en body)
        let body: [String: Any] = ["donationId": donationId]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        // Petición
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error al actualizar la donación:", error)
                return
            }

            guard let http = response as? HTTPURLResponse else { return }

            if http.statusCode == 200 || http.statusCode == 204 {
                print("Donación actualizada correctamente")
                return
            }

            print("Respuesta inesperada del servidor:", http.statusCode)

        }
        task.resume()
    }
