import UIKit
import PDFKit

class ShareViewBuilder {

    static func build(
        in view: UIView,
        imageView: UIImageView,
        pdfView: PDFView,
        sendButton: UIButton,
        closeButton: UIButton,
        userButton: UIButton,
        target: Any,
        sendAction: Selector,
        closeAction: Selector
    ) {

        view.backgroundColor = .white

        // MARK: - ImageView
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        // MARK: - PDFView
        pdfView.backgroundColor = .white
        pdfView.autoScales = true
        pdfView.isHidden = true
        pdfView.translatesAutoresizingMaskIntoConstraints = false

        // MARK: - Close Button
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        let image = UIImage(systemName: "xmark", withConfiguration: config)

        closeButton.setImage(image, for: .normal)
        closeButton.tintColor = .label
        closeButton.backgroundColor = .systemGray5
        closeButton.layer.cornerRadius = 16
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(target, action: closeAction, for: .touchUpInside)

        // MARK: - Send Button
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.backgroundColor = .systemBlue
        sendButton.layer.cornerRadius = 12
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(target, action: sendAction, for: .touchUpInside)

        // MARK: - User Selection Button
        userButton.setTitle("Select Patient", for: .normal)
        userButton.backgroundColor = .systemGray6
        userButton.layer.cornerRadius = 8
        userButton.translatesAutoresizingMaskIntoConstraints = false


        // MARK: - Add subviews
        view.addSubview(closeButton)
        view.addSubview(imageView)
        view.addSubview(pdfView)
        view.addSubview(sendButton)
        view.addSubview(userButton)

        // MARK: - Constraints
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 32),
            closeButton.heightAnchor.constraint(equalToConstant: 32),

            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.bottomAnchor.constraint(equalTo: userButton.topAnchor, constant: -12),

            pdfView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 16),
            pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            pdfView.bottomAnchor.constraint(equalTo: userButton.topAnchor, constant: -12),

            userButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            userButton.bottomAnchor.constraint(equalTo: sendButton.topAnchor, constant: -12),
            userButton.heightAnchor.constraint(equalToConstant: 40),

            sendButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            sendButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
