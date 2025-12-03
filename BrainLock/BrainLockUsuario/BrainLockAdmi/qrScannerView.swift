import UIKit
import AVFoundation

class ViewController: UIViewController {

    let session = AVCaptureSession()

    // MARK: - Constants

    private enum Constants {
        static let alertTitle = "Scanning is not supported"
        static let alertMessage = "Your device does not support scanning a code from an item. Please use a device with a camera."
        static let alertButtonTitle = "OK"
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }

    // MARK: - Set up camera

    func setupCamera() {
        guard let device = AVCaptureDevice.default(for: .video) else {
            showAlert()
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: device)
            let output = AVCaptureMetadataOutput()

            session.beginConfiguration()
            
            if session.canAddInput(input) {
                session.addInput(input)
            }

            if session.canAddOutput(output) {
                session.addOutput(output)
                output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                output.metadataObjectTypes = [.qr]
            }

            session.commitConfiguration()

            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = view.bounds
            view.layer.addSublayer(previewLayer)

            // Start running session in background to avoid UI blocking
            DispatchQueue.global(qos: .userInitiated).async {
                self.session.startRunning()
            }

        } catch {
            showAlert()
            print("Camera error:", error)
        }
    }

    // MARK: - Alert

    func showAlert() {
        let alert = UIAlertController(title: Constants.alertTitle,
                                      message: Constants.alertMessage,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.alertButtonTitle,
                                      style: .default))
        present(alert, animated: true)
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension ViewController: AVCaptureMetadataOutputObjectsDelegate {

    private func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) async {

        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              metadataObject.type == .qr,
              let stringValue = metadataObject.stringValue else { return }

        print("QR Code detected:", stringValue)
        do {
            try await markDonationAsDelivered(donationId: stringValue)
        } catch {
            print("Error al actualizar la donación:", error)
        }
    }
}

func markDonationAsDelivered(donationId: String) async throws {
        let baseURL = URL(string: "http://10.14.255.216:3000")!

        // URL de tu endpoint
        guard let url = URL(string: "/donation/\(donationId)", relativeTo: baseURL) else {
            throw URLError(.badURL)
        }
    
        guard let token = try readJWTFromKeychain() else {
            throw AuthError.badStatus(401, "No token stored in Keychain")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
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

            guard let data = data,
                  let responseJSON = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                print("No se recibió respuesta válida")
                return
            }

            print("respuesta:", responseJSON)
        }
        task.resume()
    }
