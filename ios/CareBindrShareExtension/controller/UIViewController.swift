import UIKit

extension UIViewController {

    // MARK: - Alerts
    func showAlert(
        title: String = "Error",
        message: String,
        onRetry: (() -> Void)? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        // ✅ Retry button (only if provided)
        if let onRetry = onRetry {
            alert.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
                onRetry()
            })
        }

        // ✅ OK button (default behavior)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
            onDismiss?()
            self.close()
        })

        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    // MARK: - Loading Indicator
    private struct AssociatedKeys {
        static var loadingViewKey: UInt8 = 0
    }

    private var loadingView: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.loadingViewKey) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.loadingViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func showLoading() {
        guard loadingView == nil else { return } // prevent multiple overlays
        
        let overlay = UIView(frame: view.bounds)
        overlay.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.center = overlay.center
        spinner.startAnimating()
        
        overlay.addSubview(spinner)
        view.addSubview(overlay)
        
        loadingView = overlay
    }

    func hideLoading() {
        loadingView?.removeFromSuperview()
        loadingView = nil
    }
    
    private func close() {
        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
}
