//
//  VisitedPlacesView.swift
//  CWKTemplate24
//
//  Created by girish lukka on 23/10/2024.
//

import SwiftUI
import SwiftData

struct VisitedPlacesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \LocationModel.placeName, order: .forward) private var storedLocations: [LocationModel]
    
    var body: some View {
        ZStack {
            // Sky Background
            Image("sky")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Weather Locations in Database")
                    .font(.title2)
                    .foregroundColor(.black)
                    .padding(.top, 100)
                
                if storedLocations.isEmpty {
                    Text("No locations stored in the database")
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .padding()
                } else {
                    List {
                        ForEach(storedLocations, id: \.id) { location in
                            HStack {
                                HStack() {
                                    Text(location.placeName)
                                        .font(.body)
                                        .fontWeight(.medium)
                                        .foregroundColor(.black)
                                    
                                    Text("(\(location.latitude), \(location.longitude))")
                                        .font(.body)
                                        .fontWeight(.medium)
                                        .foregroundColor(.black)
                                }
                                Spacer()
                            }
                        }
                        .onDelete(perform: deleteLocation)
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(PlainListStyle())
                    .scrollContentBackground(.hidden)
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
        }
    }
    
    // MARK: - Delete Location
    private func deleteLocation(at offsets: IndexSet) {
        for index in offsets {
            let location = storedLocations[index]
            modelContext.delete(location)
        }
        do {
            try modelContext.save()
            print("Location deleted successfully")
        } catch {
            print("Error deleting location: \(error.localizedDescription)")
        }
    }
}


