//
//  LaunchTableViewCell.swift
//  Task1Mentorship
//
//  Created by Gulnaz Kaztayeva on 31.10.2025.
//
import UIKit

class LaunchTableViewCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let iconView = UIImageView()
    private let statusView = UIImageView()
    private let container = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        container.backgroundColor = UIColor(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)
        container.layer.cornerRadius = 16
        container.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(container)

        iconView.image = UIImage(systemName: "rocket.fill")
        iconView.tintColor = .white
        iconView.translatesAutoresizingMaskIntoConstraints = false

        statusView.translatesAutoresizingMaskIntoConstraints = false
        statusView.contentMode = .scaleAspectFit

        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        dateLabel.textColor = .lightGray
        dateLabel.font = .systemFont(ofSize: 13)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(iconView)
        container.addSubview(statusView)
        container.addSubview(titleLabel)
        container.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            iconView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 28),
            iconView.heightAnchor.constraint(equalToConstant: 28),

            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: statusView.leadingAnchor, constant: -8),

            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            statusView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            statusView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            statusView.widthAnchor.constraint(equalToConstant: 20),
            statusView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    func configure(with launch: Launch) {
        titleLabel.text = launch.name

        let isoFormatter = ISO8601DateFormatter()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM, yyyy"
        dateFormatter.locale = Locale(identifier: "ru_RU")

        if let date = isoFormatter.date(from: launch.date_utc) {
            dateLabel.text = dateFormatter.string(from: date)
        }

        if launch.success == true {
            statusView.image = UIImage(systemName: "checkmark.circle.fill")
            statusView.tintColor = .green
        } else {
            statusView.image = UIImage(systemName: "xmark.circle.fill")
            statusView.tintColor = .red
        }
    }
}
