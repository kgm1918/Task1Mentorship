//
//  Networking.swift
//  Task1Mentorship
//
//  Created by Gulnaz Kaztayeva on 24.11.2025.
//

import Foundation

final class Network {

    static let shared = Network()
    private init() {}

    func fetch<T: Decodable>(_ type: T.Type, from url: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: url) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
