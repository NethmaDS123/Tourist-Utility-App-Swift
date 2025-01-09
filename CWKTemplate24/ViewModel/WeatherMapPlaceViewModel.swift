//
//  WeatherMapPlaceViewModel.swift
//  CWKTemplate24
//
//  Created by girish lukka on 23/10/2024.
//
import Foundation
import CoreLocation
import MapKit
import SwiftUI
import SwiftData

class WeatherMapPlaceViewModel: ObservableObject {

    // MARK: - Published Variables
    @Published var weatherDataModel: WeatherDataModel? // Weather data
    @Published var airDataModel: AirDataModel? // Air quality data
    @Published var newLocation: String = "London" // Default location
    @Published var coordinates: CLLocationCoordinate2D? // Current coordinates
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.5072, longitude: -0.1276),
        span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
    )
    @Published var touristPlaces: [PlaceAnnotationDataModel] = [] // Tourist places
    @Published var alertMessage: String? // For alerts
    @Published var showAlert: Bool = false // Alert visibility

    // Weather API Key
    private let apiKey = "ADDKEYHERE"

    // MARK: - Initialization
    init() {
        Task {
            // Fetches initial data for London
            try? await fetchDataForLocation(latitude: 51.5072, longitude: -0.1276, locationName: "London", modelContext: nil)
        }
    }

    // MARK: - Fetches Data for Any Location
    func fetchDataForLocation(latitude: Double, longitude: Double, locationName: String, modelContext: ModelContext?) async throws {
        // Fetch weather, air quality, and tourist places for the given coordinates
        try await fetchWeatherData(lat: latitude, lon: longitude)
        try await fetchAirData(lat: latitude, lon: longitude)
        try await setAnnotations(lat: latitude, lon: longitude)
        
        // Saves the location if it's not the default (London) and modelContext is provided
        if locationName != "London", let context = modelContext {
            saveNewLocation(name: locationName, latitude: latitude, longitude: longitude, modelContext: context)
        }
    }

    // MARK: - Handle Location Change
    func changeLocation(modelContext: ModelContext) async {
        do {
            // Attempts to get coordinates for the new location
            try await getCoordinatesForCity()

            guard let coordinates = self.coordinates else { return }

            // Fetches data for the new location
            try await fetchDataForLocation(
                latitude: coordinates.latitude,
                longitude: coordinates.longitude,
                locationName: newLocation,
                modelContext: modelContext
            )
            
            // Shows success alert for valid location
            DispatchQueue.main.async {
                self.alertMessage = "The location '\(self.newLocation)' with its geo-coordinates has been added to the database."
                self.showAlert = true
            }
        } catch let error as NSError {
            // Handles invalid location error
            DispatchQueue.main.async {
                self.alertMessage = error.localizedDescription
                self.showAlert = true
            }
        }
    }




    // MARK: - Fetches Coordinates for a Place Using Geocoding
    func getCoordinatesForCity() async throws {
        let geocoder = CLGeocoder()
        do {
            let placemarks = try await geocoder.geocodeAddressString(newLocation)
            if let placemark = placemarks.first,
               let location = placemark.location?.coordinate,
               let name = placemark.name, !name.isEmpty {
                DispatchQueue.main.async {
                    self.coordinates = location
                    self.region = MKCoordinateRegion(
                        center: location,
                        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                    )
                }
            } else {
                throw NSError(domain: "InvalidLocation", code: 404, userInfo: [NSLocalizedDescriptionKey: "No such location found."])
            }
        } catch {
            throw NSError(domain: "InvalidLocation", code: 404, userInfo: [NSLocalizedDescriptionKey: "No such location found."])
        }
    }
    
    
    func validateAndChangeLocation(locationName: String, modelContext: ModelContext) async throws {
        let geocoder = CLGeocoder()
        do {
            let placemarks = try await geocoder.geocodeAddressString(locationName)
            
            // Validates geocoded result
            if let placemark = placemarks.first,
               let location = placemark.location?.coordinate,
               let name = placemark.name, !name.isEmpty {
                
                DispatchQueue.main.async {
                    // Updates newLocation only after successful validation
                    self.newLocation = locationName
                    self.coordinates = location
                    self.region = MKCoordinateRegion(
                        center: location,
                        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                    )
                }
                
                // Fetches and updates data for the new location
                try await fetchDataForLocation(
                    latitude: location.latitude,
                    longitude: location.longitude,
                    locationName: locationName,
                    modelContext: modelContext
                )
            } else {
                throw NSError(domain: "InvalidLocation", code: 404, userInfo: [NSLocalizedDescriptionKey: "No such location found."])
            }
        } catch {
            throw NSError(domain: "InvalidLocation", code: 404, userInfo: [NSLocalizedDescriptionKey: "No such location found."])
        }
    }


    // MARK: - Save Location to Database
    func saveNewLocation(name: String, latitude: Double, longitude: Double, modelContext: ModelContext) {
        let newLocation = LocationModel(placeName: name, latitude: latitude, longitude: longitude)
        modelContext.insert(newLocation)
        do {
            try modelContext.save()
            print("Location saved: \(name) (\(latitude), \(longitude))")
        } catch {
            print("Error saving location: \(error.localizedDescription)")
        }
    }

    
    // MARK: - Fetch Weather Data
    func fetchWeatherData(lat: Double, lon: Double) async throws {
        // Construct API URL with latitude and longitude
        guard let url = URL(string: "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(lon)&units=metric&appid=\(apiKey)") else {
            fatalError("Invalid weather API URL") // Handle invalid URL
        }

        do {
            // Perform network request
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw NSError(domain: "WeatherAPIError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch weather data."])
            }
            // Decode JSON response into a weather data model
            let decodedData = try JSONDecoder().decode(WeatherDataModel.self, from: data)
            DispatchQueue.main.async {
                self.weatherDataModel = decodedData // Update the weather data model
            }
        } catch {
            DispatchQueue.main.async {
                self.alertMessage = "Error fetching weather data: \(error.localizedDescription)" // Display error message
                self.showAlert = true
            }
            throw error // Rethrow error for further handling
        }
    }


    // MARK: - Fetch Air Quality Data
    func fetchAirData(lat: Double, lon: Double) async throws {
        // Construct API URL with latitude and longitude
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/air_pollution?lat=\(lat)&lon=\(lon)&appid=\(apiKey)") else {
            fatalError("Invalid air quality API URL") // Handle invalid URL
        }

        do {
            // Perform network request
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw NSError(domain: "AirQualityAPIError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch air quality data."])
            }
            // Decode JSON response into an air quality data model
            let decodedData = try JSONDecoder().decode(AirDataModel.self, from: data)
            DispatchQueue.main.async {
                self.airDataModel = decodedData // Update the air quality data model
            }
        } catch {
            DispatchQueue.main.async {
                self.alertMessage = "Error fetching air quality data: \(error.localizedDescription)" // Display error message
                self.showAlert = true
            }
            throw error // Rethrow error for further handling
        }
    }


    // MARK: - Fetch Tourist Places
    func setAnnotations(lat: Double, lon: Double) async throws {
        // Define map region for the search
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: lat, longitude: lon),
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "tourist attraction" // Search query
        request.region = region // Specify the search region

        let search = MKLocalSearch(request: request)
        do {
            let response = try await search.start() // Perform the search
            DispatchQueue.main.async {
                self.touristPlaces = response.mapItems.prefix(5).map {
                    PlaceAnnotationDataModel(
                        name: $0.name ?? "Unknown", // Extract place name
                        coordinate: $0.placemark.coordinate // Extract coordinates
                    )
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.alertMessage = "Error fetching tourist places: \(error.localizedDescription)" // Display error message
                self.showAlert = true
            }
            throw error // Rethrow error for further handling
        }
    }

}
