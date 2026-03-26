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
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    // User selection
    private var selectedUserId: String?
    
    // Dummy users
    private var users: [UserSummary] = []
    
    // MARK: - Handlers
    private var shareHandler: ShareHandler!

    private var loadingView: UIView?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard isUserLoggedIn() else {
            handleNotLoggedIn()
            return
        }

        setupUI()
        setupLoadingIndicator()
        configureUIBasedOnRole()
        initializeShareHandler()
        
        refreshTokenAndPrepare()
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
        setLoading(true)
        shareHandler.selectedPatientId = selectedUserId

        shareHandler.sendFile() { [weak self] success, errorMessage in
            DispatchQueue.main.async {
                self?.setLoading(false)
                if success {
                    self?.close()
                } else {
                    self?.showAlert(message: errorMessage ?? "Something went wrong",onRetry: { [weak self] in
                        self?.sendTapped() // retry same action
                    })
                }
            }
        }
    }
    
    @objc private func closeTapped() {
        close()
    }
    
    private func isUserLoggedIn() -> Bool {
        return UserManager.getAccessToken() != nil
    }
    
    private func initializeShareHandler() {
        shareHandler = ShareHandler(imageView: imageView, pdfView: pdfView)
        shareHandler.handleSharedItems(from: extensionContext)
    }
    
    private func setupLoadingIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .white
        
        sendButton.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: sendButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor)
        ])
    }
    
    private func setLoading(_ isLoading: Bool) {
        sendButton.isEnabled = !isLoading
        userButton.isEnabled = !isLoading
        closeButton.isEnabled = !isLoading

        if isLoading {
            sendButton.setTitle("", for: .normal)
            activityIndicator.startAnimating()
        } else {
            sendButton.setTitle("Send", for: .normal)
            activityIndicator.stopAnimating()
        }
    }
    
    private func handleNotLoggedIn() {
            let alert = UIAlertController(
                title: "Login Required",
                message: "Please log in to CareBinder to share files.",
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                self.close()
            })

            present(alert, animated: true)
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
    
    private func refreshTokenAndPrepare() {
        self.showLoading()
        
        if !UserManager.isAccessTokenExpired() {
            print("✅ Access token is still valid — no need to refresh")
            GetPatientList()
            return
        }

        print("🔄 Access token expired — refreshing...")
        
        
        AuthService.refreshToken { [weak self] token, error in
            
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let error = error {
                    self.showAlert(message: error)
                    self.hideLoading()
                    return
                }

                guard token != nil else {
                    self.showAlert(message: "Token refresh failed")
                    self.hideLoading()
                    return
                }

                print("✅ Token refreshed")
                self.GetPatientList()
            }
        }
    }
    
    private func GetPatientList(){
        let role = UserManager.getUserRole()
        print("User Role:", role ?? "nil")
        
        let isCaregiver = (role == "CAREGIVER")
        
        guard isCaregiver else {
            self.hideLoading()
            return
        }
        
        PatientService.getPatients { patients, error in
            
            DispatchQueue.main.async {
                
                self.hideLoading()
                
                if let error = error {
                    self.showAlert(message: error)
                    return
                }

                guard let patients = patients else {
                    self.showAlert(message: "No patients found")
                    return
                }
                
                if patients.isEmpty {
                    self.showAlert(message: "No patients with full access")
                    return
                }

                self.users = patients
                self.setupUserDropdown()
            }
        }
    }
    
    private func close() {
        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
}
