import UIKit

class SettingsViewController: UIViewController {
    
    private let heightMButton = UIButton()
    private let heightFtButton = UIButton()
    private let diameterMButton = UIButton()
    private let diameterFtButton = UIButton()
    private let massKgButton = UIButton()
    private let massLbButton = UIButton()
    private let payloadKgButton = UIButton()
    private let payloadLbButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupHeader()
        setupUI()
    }
    
    private func setupHeader() {
        let titleLabel = UILabel()
        titleLabel.text = "Настройки"
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 18)
        
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Закрыть", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        
        [titleLabel, closeButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupUI() {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        stack.addArrangedSubview(makeSettingRow(title: "Высота", left: heightMButton, right: heightFtButton, leftTitle: "m", rightTitle: "ft"))
        stack.addArrangedSubview(makeSettingRow(title: "Диаметр", left: diameterMButton, right: diameterFtButton, leftTitle: "m", rightTitle: "ft"))
        stack.addArrangedSubview(makeSettingRow(title: "Масса", left: massKgButton, right: massLbButton, leftTitle: "kg", rightTitle: "lb"))
        stack.addArrangedSubview(makeSettingRow(title: "Полезная нагрузка", left: payloadKgButton, right: payloadLbButton, leftTitle: "kg", rightTitle: "lb"))
        
        [heightFtButton, diameterFtButton, massKgButton, payloadLbButton].forEach { selectButton($0) }
    }
    
    private func makeSettingRow(title: String, left: UIButton, right: UIButton, leftTitle: String, rightTitle: String) -> UIStackView {
        let label = UILabel()
        label.text = title
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        
        let buttonStack = UIStackView(arrangedSubviews: [left, right])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 8
        
        [left, right].forEach {
            styleButton($0)
            $0.widthAnchor.constraint(equalToConstant: 50).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 32).isActive = true
        }
        
        left.setTitle(leftTitle, for: .normal)
        right.setTitle(rightTitle, for: .normal)
        
        left.addTarget(self, action: #selector(toggleButton(_:)), for: .touchUpInside)
        right.addTarget(self, action: #selector(toggleButton(_:)), for: .touchUpInside)
        
        let row = UIStackView(arrangedSubviews: [label, buttonStack])
        row.axis = .horizontal
        row.distribution = .equalSpacing
        return row
    }
    
    private func styleButton(_ button: UIButton) {
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.black, for: .selected)
        button.backgroundColor = UIColor(white: 0.15, alpha: 1)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
    }
    
    @objc private func toggleButton(_ sender: UIButton) {
        guard let row = sender.superview as? UIStackView else { return }
        for case let button as UIButton in row.arrangedSubviews {
            button.isSelected = false
            button.backgroundColor = UIColor(white: 0.15, alpha: 1)
        }
        sender.isSelected = true
        sender.backgroundColor = .white
    }
    
    private func selectButton(_ button: UIButton) {
        button.isSelected = true
        button.backgroundColor = .white
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
}
