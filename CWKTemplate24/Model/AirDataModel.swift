//
//  AirDataModel.swift
//  CWKTemplate24
//
//  Created by girish lukka on 23/10/2024.
//

import Foundation
// Represents air quality data retrieved from the API
struct AirDataModel: Codable {
    let coord: Coord? // Coordinates of the location
    let list: [AirDataEntry] // List of air quality entries
}

struct Coord: Codable {
    let lon, lat: Double // Longitude and latitude
}

struct AirDataEntry: Codable {
    let main: AirMain // Air Quality Index (AQI)
    let components: AirComponents // Individual air components (e.g., CO, SO2)
    let dt: Int // Date-time of the entry
}

struct AirMain: Codable {
    let aqi: Int // Air Quality Index value
}

struct AirComponents: Codable {
    let co, no, no2, o3: Double // Air pollutants
    let so2, pm2_5, pm10, nh3: Double
}

// Extension to convert air components to key-value pairs for easy display
extension AirComponents {
    func toKeyValueArray() -> [(key: String, value: Double)] {
        return [
            (key: "SO2", value: so2),
            (key: "NO2", value: no2),
            (key: "VOC", value: co),
            (key: "PM", value: pm10)
        ]
    }
}
