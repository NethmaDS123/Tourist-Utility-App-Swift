//
//  NavBarView.swift
//  CWKTemplate24
//
//  Created by girish lukka on 23/10/2024.
//

import SwiftUI

struct NavBarView: View {
    
    @EnvironmentObject var weatherMapPlaceViewModel: WeatherMapPlaceViewModel
    @Environment(\.modelContext) private var modelContext
    @State private var newLocationInput: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        // Set the background image
        if let image = UIImage(named: "sky") {
            appearance.backgroundImage = image
        }
        
        // Set the item appearance
        appearance.stackedLayoutAppearance.normal.iconColor = .black
        appearance.stackedLayoutAppearance.selected.iconColor = .blue
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        VStack {
            Image("BG")
                .resizable()
                .scaledToFill()
                .frame(height: 0) 
            
            VStack {
                // MARK: - Location Change UI
                HStack {
                    Text("Change Location")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    TextField("Enter New Location", text: $newLocationInput, onCommit: {
                        Task { @MainActor in
                            do {
                                try await weatherMapPlaceViewModel.validateAndChangeLocation(
                                    locationName: newLocationInput,
                                    modelContext: modelContext
                                )
                                alertMessage = "The location '\(newLocationInput)' with its geo-coordinates has been added to the database."
                                showAlert = true
                            } catch {
                                alertMessage = error.localizedDescription
                                showAlert = true
                            }
                        }
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: 200)
                }
                .padding()
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Location Update"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            
            // MARK: - TabView
            TabView {
                CurrentWeatherView()
                    .tabItem {
                        Image(systemName: "sun.max.fill").scaleEffect(1.4)
                        Text("Now")
                    }
                
                ForecastWeatherView()
                    .tabItem {
                        Image(systemName: "calendar").scaleEffect(1.4)
                        Text("5-Day")
                    }
                
                MapView()
                    .tabItem {
                        Image(systemName: "map").scaleEffect(1.4)
                        Text("Map")
                    }
                
                VisitedPlacesView()
                    .tabItem {
                        Image(systemName: "globe").scaleEffect(1.4)
                        Text("Visited")
                    }
            }
            .onAppear {
                Task { @MainActor in
                    do {
                        try await weatherMapPlaceViewModel.fetchDataForLocation(
                            latitude: 51.5072,
                            longitude: -0.1276,
                            locationName: "London",
                            modelContext: modelContext
                        )
                    } catch {
                        alertMessage = "Failed to fetch initial data for London: \(error.localizedDescription)"
                        showAlert = true
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Location Updated"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

// MARK: - Preview
#Preview {
    NavBarView()
        .environmentObject(WeatherMapPlaceViewModel())
}

