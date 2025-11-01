//
//  Rocket.swift
//  Task1Mentorship
//
//  Created by Gulnaz Kaztayeva on 30.10.2025.
//
import Foundation

struct Rocket: Decodable {
    let id: String
    let name: String
    let height: MeasurementValues
    let diameter: MeasurementValues
    let mass: MassValues
    let payload_weights: [PayloadWeight]
    let first_flight: String
    let country: String
    let cost_per_launch: Int
    let first_stage: StageInfo
    let second_stage: StageInfo
    let flickr_images: [String]
}

struct MeasurementValues: Decodable {
    let meters: Double?
    let feet: Double?
}

struct MassValues: Decodable {
    let kg: Double?
    let lb: Double?
}

struct PayloadWeight: Decodable {
    let id: String
    let name: String
    let kg: Int?
    let lb: Int?
}

struct StageInfo: Decodable {
    let engines: Int?
    let fuel_amount_tons: Double?
    let burn_time_sec: Int?
}
