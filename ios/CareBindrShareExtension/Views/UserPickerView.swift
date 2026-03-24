import UIKit

class UserPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {

    private let button = UIButton(type: .system)
    private let picker = UIPickerView()
    private var users: [(id: String, name: String)] = []
    private var selectedUserId: String?

    var onUserSelected: ((String) -> Void)?

    private var pickerHeightConstraint: NSLayoutConstraint!

    init(users: [(id: String, name: String)]) {
        super.init(frame: .zero)
        self.users = users
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        // Button
        button.setTitle("Select User ▼", for: .normal)
        button.backgroundColor = UIColor.systemGray6
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(togglePicker), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)

        // Picker
        picker.delegate = self
        picker.dataSource = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        addSubview(picker)

        pickerHeightConstraint = picker.heightAnchor.constraint(equalToConstant: 0)
        pickerHeightConstraint.isActive = true

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.heightAnchor.constraint(equalToConstant: 40),

            picker.topAnchor.constraint(equalTo: button.bottomAnchor),
            picker.leadingAnchor.constraint(equalTo: leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: trailingAnchor),
            picker.bottomAnchor.constraint(equalTo: bottomAnchor) // ensures UserPickerView expands when picker opens
        ])
    }

    @objc private func togglePicker() {
        let isOpening = pickerHeightConstraint.constant == 0
        pickerHeightConstraint.constant = isOpening ? 150 : 0
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }

    // MARK: - Picker DataSource & Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { users.count }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { users[row].name }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedUserId = users[row].id
        button.setTitle(users[row].name + " ▼", for: .normal)
        onUserSelected?(selectedUserId!)
        togglePicker() // collapse after selection
    }

    func getSelectedUserId() -> String? {
        return selectedUserId ?? users.first?.id
    }
}
