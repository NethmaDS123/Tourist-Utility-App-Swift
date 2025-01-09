//
//  MapView.swift
//  CWKTemplate24
//
//  Created by girish lukka on 23/10/2024.
//
import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var weatherMapPlaceViewModel: WeatherMapPlaceViewModel

    var body: some View {
        ZStack {
            // Sky background
            Image("sky")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 10) {
                // Map Section
                if !weatherMapPlaceViewModel.touristPlaces.isEmpty {
                    Map(
                        coordinateRegion: $weatherMapPlaceViewModel.region,
                        interactionModes: [.zoom, .pan],
                        annotationItems: weatherMapPlaceViewModel.touristPlaces
                    ) { place in
                        // For each item, return a MapAnnotation
                        MapAnnotation(coordinate: place.coordinate) {
                            VStack {
                                Image(systemName: "mappin")
                                    .font(.largeTitle)
                                    .foregroundColor(.red)
                                Text(place.name)
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                    .frame(height: 300)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.top, 50)
                } else {
                    Text("Loading map...")
                        .foregroundColor(.gray)
                        .frame(height: 300)
                }

                // Tourist Places List
                VStack(alignment: .leading, spacing: 10) {
                    Text("Top 5 Tourist Attractions in \(weatherMapPlaceViewModel.newLocation)")
                        .font(.title3)
                        .padding(.horizontal)
                        .padding(.top, 10)
                        

                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(weatherMapPlaceViewModel.touristPlaces, id: \.id) { place in
                                HStack(spacing: 10) {
                                    Image(systemName: "mappin.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.red)
                                    Text(place.name)
                                        .font(.body)
                                        .foregroundColor(.primary)
                                        .lineLimit(1)
                                    Spacer()
                                }
                                
                                .background(Color.white.opacity(0))
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .background(Color.white.opacity(0))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.bottom, 10)
                
            }
        }
        .onAppear {
            // Center map on coordinates if available
            if let coordinates = weatherMapPlaceViewModel.coordinates {
                weatherMapPlaceViewModel.region.center = coordinates
            }
        }
    }
}

#Preview {
    MapView()
        .environmentObject(WeatherMapPlaceViewModel())
}
