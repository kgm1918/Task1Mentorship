//
//  RocketViewController.swift
//  Task1Mentorship
//
//  Created by Gulnaz Kaztayeva on 31.10.2025.
//
import UIKit

final class RocketViewController: UIViewController {
    enum Section: Int, CaseIterable {
        case header
        case params
        case info
        case firstStage
        case secondStage
        case button
    }

    var rocket: Rocket!

    private var collectionView: UICollectionView!

    private let placeholderLocalImagePath = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureCollectionView()
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collectionView.backgroundColor = .black
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self

        collectionView.register(HeaderCell.self, forCellWithReuseIdentifier: HeaderCell.reuseId)
        collectionView.register(ParamCell.self, forCellWithReuseIdentifier: ParamCell.reuseId)
        collectionView.register(InfoCell.self, forCellWithReuseIdentifier: InfoCell.reuseId)
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: ButtonCell.reuseId)

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

   
    private func makeLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, env in
            guard let section = Section(rawValue: sectionIndex) else { return nil }
            switch section {
            case .header:
                let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .absolute(300))
                let item = NSCollectionLayoutItem(layoutSize: size)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
                let sectionLayout = NSCollectionLayoutSection(group: group)
                return sectionLayout

            case .params:
                let fraction: CGFloat = 1.0 / 3.0
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction),
                                                      heightDimension: .absolute(90))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(90))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let sectionLayout = NSCollectionLayoutSection(group: group)
                sectionLayout.orthogonalScrollingBehavior = .continuous
                sectionLayout.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0)
                
                return sectionLayout


            case .info, .firstStage, .secondStage:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
                let sectionLayout = NSCollectionLayoutSection(group: group)
                sectionLayout.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
                return sectionLayout

            case .button:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(70))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
                let sectionLayout = NSCollectionLayoutSection(group: group)
                sectionLayout.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 70, bottom: 40, trailing: 70)
                return sectionLayout
            }
        }
    }
}

extension RocketViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int { Section.allCases.count }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .header, .button: return 1
        case .params: return 4
        case .info: return 3
        case .firstStage, .secondStage: return 3
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch Section(rawValue: indexPath.section)! {
        case .header:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCell.reuseId, for: indexPath) as! HeaderCell
            cell.configure(with: rocket, placeholderPath: placeholderLocalImagePath)
            cell.settingsAction = { [weak self] in
                guard let self = self else { return }
                let vc = SettingsViewController()
                vc.modalPresentationStyle = .formSheet
                self.present(vc, animated: true)
            }
            return cell

        case .params:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParamCell.reuseId, for: indexPath) as! ParamCell
            
            let titles = ["Высота", "Диаметр", "Масса", "Полезная нагрузка"]
            
            let heightNumber = rocket.height.feet.map { "\($0)" } ?? "—"
            let diameterNumber = rocket.diameter.feet.map { "\($0)" } ?? "—"
            let massNumber = rocket.mass.lb.map { "\($0)" } ?? "—"

            let payloadLeo = rocket.payload_weights.first(where: { $0.id.lowercased() == "leo" })
            let payloadNumber: String
            if let kg = payloadLeo?.kg {
                payloadNumber = "\(kg)"
            } else if let lb = payloadLeo?.lb {
                payloadNumber = "\(lb)"
            } else {
                payloadNumber = "—"
            }

            let numbers = [heightNumber, diameterNumber, massNumber, payloadNumber]
            let units = ["ft", "ft", "lb", "kg"]

            
            cell.configure(
                number: numbers[indexPath.item],
                unit: units[indexPath.item],
                title: titles[indexPath.item]
            )
            
            return cell


        case .info:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCell.reuseId, for: indexPath) as! InfoCell
            let titles = ["Первый запуск", "Страна", "Стоимость"]
            let values = [
                rocket.first_flight,
                rocket.country,
                "$\(rocket.cost_per_launch / 1_000_000) млн"
            ]
            cell.configure(title: titles[indexPath.item], value: values[indexPath.item])
            return cell

        case .firstStage:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCell.reuseId, for: indexPath) as! InfoCell
            let titles = ["Количество двигателей", "Количество топлива", "Время сгорания"]
            let stage = rocket.first_stage
            let values = [
                "\(stage.engines ?? 0)",
                "\(stage.fuel_amount_tons ?? 0) ton",
                "\(stage.burn_time_sec ?? 0) sec"
            ]
            cell.configure(title: titles[indexPath.item], value: values[indexPath.item])
            return cell

        case .secondStage:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCell.reuseId, for: indexPath) as! InfoCell
            let titles = ["Количество двигателей", "Количество топлива", "Время сгорания"]
            let stage = rocket.second_stage
            let values = [
                "\(stage.engines ?? 0)",
                "\(stage.fuel_amount_tons ?? 0) ton",
                "\(stage.burn_time_sec ?? 0) sec"
            ]
            cell.configure(title: titles[indexPath.item], value: values[indexPath.item])
            return cell

        case .button:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCell.reuseId, for: indexPath) as! ButtonCell
            cell.buttonAction = { [weak self] in
                guard let self = self else { return }
                let vc = LaunchViewController()
                vc.modalPresentationStyle = .fullScreen
                vc.rocketId = self.rocket.id
                vc.rocketName = self.rocket.name
                self.present(vc, animated: true)
            }
            return cell
        }
    }
}

private final class HeaderCell: UICollectionViewCell {
    static let reuseId = "HeaderCell"

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = false
        iv.layer.cornerRadius = 0
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let blackBackground: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.masksToBounds = true
        return v
    }()

    private let nameLabel: UILabel = {
        let l = UILabel()
        l.font = .boldSystemFont(ofSize: 24)
        l.textColor = .white
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let settingsButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(UIImage(systemName: "gearshape"), for: .normal)
        b.tintColor = .white
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    var settingsAction: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.addSubview(imageView)
        contentView.addSubview(blackBackground)
        blackBackground.addSubview(nameLabel)
        blackBackground.addSubview(settingsButton)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 300),

            blackBackground.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -48),
            blackBackground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            blackBackground.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            blackBackground.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            nameLabel.topAnchor.constraint(equalTo: blackBackground.topAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: blackBackground.leadingAnchor, constant: 20),

            settingsButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            settingsButton.trailingAnchor.constraint(equalTo: blackBackground.trailingAnchor, constant: -20)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with rocket: Rocket, placeholderPath: String) {
        nameLabel.text = rocket.name
        imageView.image = nil

        if let str = rocket.flickr_images.first, let url = URL(string: str) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let img = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageView.image = img
                    }
                }
            }
        } else if !placeholderPath.isEmpty {
            imageView.image = UIImage(contentsOfFile: placeholderPath)
        }

        settingsButton.addTarget(self, action: #selector(didTapSettings), for: .touchUpInside)
    }

    @objc private func didTapSettings() {
        settingsAction?()
    }
}


private final class ParamCell: UICollectionViewCell {
    static let reuseId = "ParamCell"

    private let container: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)
        v.layer.cornerRadius = 16
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let valueLabel: UILabel = {
        let l = UILabel()
        l.font = .boldSystemFont(ofSize: 18)
        l.textColor = .white
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12)
        l.textColor = .lightGray
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(container)
        container.addSubview(valueLabel)
        container.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            container.widthAnchor.constraint(equalToConstant: 140),
            container.heightAnchor.constraint(equalToConstant: 90),

            valueLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            valueLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),

            titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 4),
            titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(number: String, unit: String, title: String) {
        valueLabel.text = number
        titleLabel.text = "\(title), \(unit)"
    }

}

private final class InfoCell: UICollectionViewCell {
    static let reuseId = "InfoCell"

    private let leftLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 15)
        l.textColor = .lightGray
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let rightLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 15)
        l.textColor = .white
        l.textAlignment = .right
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let separator: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white.withAlphaComponent(0.06)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(leftLabel)
        contentView.addSubview(rightLabel)
        contentView.addSubview(separator)

        NSLayoutConstraint.activate([
            leftLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            leftLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            leftLabel.trailingAnchor.constraint(lessThanOrEqualTo: rightLabel.leadingAnchor, constant: -8),

            rightLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            rightLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            separator.topAnchor.constraint(equalTo: leftLabel.bottomAnchor, constant: 8),
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(title: String, value: String) {
        leftLabel.text = title
        rightLabel.text = value
    }
}

private final class ButtonCell: UICollectionViewCell {
    static let reuseId = "ButtonCell"
    var buttonAction: (() -> Void)?

    private let button: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Посмотреть запуски", for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.backgroundColor = .white
        b.layer.cornerRadius = 10
        b.titleLabel?.font = .boldSystemFont(ofSize: 18)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(button)

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: 52)
        ])

        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }

    required init?(coder: NSCoder) { fatalError() }

    @objc private func didTap() { buttonAction?() }
}

