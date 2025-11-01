import UIKit

class RocketViewController: UIViewController {
    var rocket: Rocket?

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let rocketImageView = UIImageView()
    private let blackBackgroundView = UIView()
    private let nameLabel = UILabel()
    private let settingsButton = UIButton()
    private let paramsStack = UIStackView()
    private let infoStack = UIStackView()
    private let button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if let rocket = rocket {
            configure(with: rocket)
        }
    }

    private func setupUI() {
        view.backgroundColor = .black
     
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        rocketImageView.contentMode = .scaleAspectFill
        rocketImageView.clipsToBounds = true
        rocketImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rocketImageView)

        NSLayoutConstraint.activate([
            rocketImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            rocketImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rocketImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rocketImageView.heightAnchor.constraint(equalToConstant: 250)
        ])

        blackBackgroundView.backgroundColor = .black
        blackBackgroundView.layer.cornerRadius = 32
        blackBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        blackBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(blackBackgroundView)

        NSLayoutConstraint.activate([
            blackBackgroundView.topAnchor.constraint(equalTo: rocketImageView.bottomAnchor, constant: -40),
            blackBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            blackBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            blackBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        nameLabel.font = .boldSystemFont(ofSize: 24)
        nameLabel.textColor = .white

        settingsButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        settingsButton.tintColor = .white
        settingsButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)

        [nameLabel, settingsButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            blackBackgroundView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: blackBackgroundView.topAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: blackBackgroundView.leadingAnchor, constant: 20),

            settingsButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            settingsButton.trailingAnchor.constraint(equalTo: blackBackgroundView.trailingAnchor, constant: -20)
        ])

        let paramsScroll = UIScrollView()
        paramsScroll.showsHorizontalScrollIndicator = false
        paramsScroll.translatesAutoresizingMaskIntoConstraints = false
        blackBackgroundView.addSubview(paramsScroll)

        paramsStack.axis = .horizontal
        paramsStack.spacing = 12
        paramsStack.alignment = .fill
        paramsStack.distribution = .fill
        paramsStack.translatesAutoresizingMaskIntoConstraints = false
        paramsScroll.addSubview(paramsStack)

        NSLayoutConstraint.activate([
            paramsScroll.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            paramsScroll.leadingAnchor.constraint(equalTo: blackBackgroundView.leadingAnchor),
            paramsScroll.trailingAnchor.constraint(equalTo: blackBackgroundView.trailingAnchor),
            paramsScroll.heightAnchor.constraint(equalToConstant: 100),

            paramsStack.topAnchor.constraint(equalTo: paramsScroll.topAnchor),
            paramsStack.bottomAnchor.constraint(equalTo: paramsScroll.bottomAnchor),
            paramsStack.leadingAnchor.constraint(equalTo: paramsScroll.leadingAnchor, constant: 16),
            paramsStack.trailingAnchor.constraint(equalTo: paramsScroll.trailingAnchor, constant: -16),
            paramsStack.heightAnchor.constraint(equalTo: paramsScroll.heightAnchor)
        ])

        infoStack.axis = .vertical
        infoStack.spacing = 15
        infoStack.translatesAutoresizingMaskIntoConstraints = false

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Посмотреть запуски", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(openLaunches), for: .touchUpInside)
        contentView.addSubview(infoStack)
        contentView.addSubview(button)

        NSLayoutConstraint.activate([
            infoStack.topAnchor.constraint(equalTo: paramsScroll.bottomAnchor, constant: 50),
            infoStack.leadingAnchor.constraint(equalTo: blackBackgroundView.leadingAnchor, constant: 20),
            infoStack.trailingAnchor.constraint(equalTo: blackBackgroundView.trailingAnchor, constant: -20),

            button.topAnchor.constraint(equalTo: infoStack.bottomAnchor, constant: 40),
            button.leadingAnchor.constraint(equalTo: blackBackgroundView.leadingAnchor, constant: 70),
            button.trailingAnchor.constraint(equalTo: blackBackgroundView.trailingAnchor, constant: -70),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60)
        ])

    }

    private func configure(with rocket: Rocket) {
        nameLabel.text = rocket.name

        if let url = URL(string: rocket.flickr_images.first ?? "") {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.rocketImageView.image = image
                    }
                }
            }
        }

        paramsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        var payloadValue = "—"
        if let leo = rocket.payload_weights.first(where: { $0.id.lowercased() == "leo" }) {
            if let kg = leo.kg {
                payloadValue = "\(Int(kg)) kg"
            } else if let lb = leo.lb {
                payloadValue = "\(Int(lb)) lb"
            }
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","

        let massValue = numberFormatter.string(from: NSNumber(value: rocket.mass.lb ?? 0)) ?? "0"

        let params = [
            ("\(Double(rocket.height.feet ?? 0))", "Высота, ft"),
            ("\(Double(rocket.diameter.feet ?? 0))", "Диаметр, ft"),
            ("\(massValue)", "Масса, lb"),
            (payloadValue, "Полезная нагрузка (LEO)")
        ]

        for (val, title) in params {
            paramsStack.addArrangedSubview(makeCard(title: title, value: val))
        }

        infoStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        addInfoRow("Первый запуск", rocket.first_flight)
        addInfoRow("Страна", rocket.country)
        addInfoRow("Стоимость запуска", "$\(rocket.cost_per_launch / 1_000_000) млн")

        addSectionTitle("ПЕРВАЯ СТУПЕНЬ")
        addInfoRow("Количество двигателей", "\(rocket.first_stage.engines ?? 0)")
        addInfoRow("Количество топлива", "\(rocket.first_stage.fuel_amount_tons ?? 0) ton")
        addInfoRow("Время сгорания в секундах", "\(rocket.first_stage.burn_time_sec ?? 0) sec")
        
        addSectionTitle("ВТОРАЯ СТУПЕНЬ")
        addInfoRow("Количество двигателей", "\(rocket.second_stage.engines ?? 0)")
        addInfoRow("Количество топлива", "\(rocket.second_stage.fuel_amount_tons ?? 0) ton")
        addInfoRow("Время сгорания в секундах", "\(rocket.second_stage.burn_time_sec ?? 0) sec")
    }

    private func makeCard(title: String, value: String) -> UIView {
        let v = UIView()
        v.backgroundColor = UIColor(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)
        v.layer.cornerRadius = 16
        v.layer.borderWidth = 0.5
        v.layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor

        let valLabel = UILabel()
        valLabel.text = value
        valLabel.font = .boldSystemFont(ofSize: 18)
        valLabel.textColor = .white

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textColor = .lightGray

        let stack = UIStackView(arrangedSubviews: [valLabel, titleLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false

        v.addSubview(stack)
        NSLayoutConstraint.activate([
            v.widthAnchor.constraint(equalToConstant: 140),
            v.heightAnchor.constraint(equalToConstant: 90),
            stack.centerXAnchor.constraint(equalTo: v.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: v.centerYAnchor)
        ])

        return v
    }

    private func addSectionTitle(_ title: String) {
        let label = UILabel()
        label.text = title
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        infoStack.addArrangedSubview(label)
    }

    private func addInfoRow(_ title: String, _ value: String) {
        let row = UIStackView()
        row.axis = .horizontal
        row.distribution = .equalSpacing
        let left = UILabel()
        left.text = title
        left.textColor = .lightGray
        let right = UILabel()
        right.text = value
        right.textColor = .white
        row.addArrangedSubview(left)
        row.addArrangedSubview(right)
        infoStack.addArrangedSubview(row)
    }
    @objc private func openLaunches() {
        let vc = LaunchViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.rocketId = rocket?.id
        vc.rocketName = rocket?.name
        present(vc, animated: true)
    }
    @objc private func openSettings() {
        let vc = SettingsViewController()
        vc.modalPresentationStyle = .formSheet
//        vc.delegate = self
        present(vc, animated: true)
    }

}
