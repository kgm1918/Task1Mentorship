//
//  LaunchViewController.swift
//  Task1Mentorship
//
//  Created by Gulnaz Kaztayeva on 31.10.2025.
//
import UIKit

class LaunchViewController: UIViewController, UITableViewDataSource {
    var rocketId: String?
    var rocketName: String?
    private var launches: [Launch] = []

    private let tableView = UITableView()
    private let titleLabel = UILabel()
    private let backButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        loadLaunches()
    }

    private func setupUI() {
        // Назад
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .white
        backButton.setTitle(" Назад", for: .normal)
        backButton.titleLabel?.font = .systemFont(ofSize: 16)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)

        // Название ракеты
        titleLabel.text = rocketName ?? "Запуски"
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Таблица
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.register(LaunchTableViewCell.self, forCellReuseIdentifier: "LaunchCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 80
        tableView.showsVerticalScrollIndicator = false

        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),

            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            tableView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func loadLaunches() {
        guard let rocketId = rocketId else { return }

        Network.shared.fetch([Launch].self, from: "https://api.spacexdata.com/v5/launches") { result in
            switch result {
            case .success(let allLaunches):
                self.launches = allLaunches
                    .filter { $0.rocket == rocketId }
                    .sorted { $0.date_utc > $1.date_utc }
                self.tableView.reloadData()

            case .failure(let error):
                print("Ошибка:", error)
            }
        }
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        launches.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let launch = launches[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "LaunchCell", for: indexPath) as! LaunchTableViewCell
        cell.configure(with: launch)
        return cell
    }

    @objc private func dismissSelf() {
        dismiss(animated: true)
    }
}
