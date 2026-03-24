import UIKit
import PDFKit
import UniformTypeIdentifiers

class ShareViewController: UIViewController {

    // MARK: - UI Components
    private let imageView = UIImageView()
    private let pdfView = PDFView()
    private let sendButton = UIButton(type: .system)
    private let closeButton = UIButton(type: .system)
    private let userButton = UIButton(type: .system)
    
    // User selection
    private var selectedUserId: String?
    
    // Dummy users
    private let users = [
        (id: "1", name: "Alice"),
        (id: "2", name: "Bob"),
        (id: "3", name: "Charlie")
    ]
    
    // MARK: - Handlers
    private var shareHandler: ShareHandler!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureUIBasedOnRole()
        
        // Initialize handler and pass UI components
        shareHandler = ShareHandler(imageView: imageView, pdfView: pdfView)
        shareHandler.handleSharedItems(from: extensionContext)
    }

    // MARK: - UI Setup
    private func setupUI() {
        sendButton.isEnabled = false
        sendButton.alpha = 0.5 // visual feedback (optional)
        
           ShareViewBuilder.build(
               in: view,
               imageView: imageView,
               pdfView: pdfView,
               sendButton: sendButton,
               closeButton: closeButton,
               userButton: userButton,
               target: self,
               sendAction: #selector(sendTapped),
               closeAction: #selector(closeTapped)
           )
    }
    
    // MARK: - Actions
    @objc private func sendTapped() {
        close()
        // Use ShareHandler to send file with selected user
//        shareHandler.sendFile() { [weak self] in
//            DispatchQueue.main.async {
//                self?.close()
//            }
//        }
    }
    
    @objc private func closeTapped() {
        close()
    }
    
    private func setupUserDropdown() {
        let actions = users.map { user in
            UIAction(title: user.name) { [weak self] _ in
                guard let self = self else { return }
                            
                    self.selectedUserId = user.id
                    self.userButton.setTitle(user.name, for: .normal)
                            
                    self.sendButton.isEnabled = true
                    self.sendButton.alpha = 1.0
            }
        }
        
        userButton.menu = UIMenu(title: "Select Patient", children: actions)
        userButton.showsMenuAsPrimaryAction = true // 👈 IMPORTANT
    }
    
    private func configureUIBasedOnRole() {
        let role = UserManager.getUserRole()
        print("User Role:", role ?? "nil")
        
        let isCaregiver = (role == "CAREGIVER")
        
        userButton.isHidden = !isCaregiver
        
        if isCaregiver {
            setupUserDropdown()
            sendButton.isEnabled = false
            sendButton.alpha = 0.5
        } else {
            sendButton.isEnabled = true
            sendButton.alpha = 1.0
        }
    }
    
    private func close() {
        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
}
