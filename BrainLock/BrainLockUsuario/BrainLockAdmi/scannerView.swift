import SwiftUI
import AVFoundation

struct ScannerView: UIViewControllerRepresentable {
    
    var onCodeScanned: (String) -> Void   // callback

    func makeUIViewController(context: Context) -> ScannerViewController {
        let vc = ScannerViewController()
        vc.onCodeScanned = onCodeScanned   
        return vc
    }

    func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) {}
}
