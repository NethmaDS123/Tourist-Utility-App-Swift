//
//  CWKTemplate24App.swift
//  CWKTemplate24
//
//  Created by girish lukka on 23/10/2024.
//

import SwiftUI
import SwiftData

@main
struct CWKTemplate24App: App {
    // MARK:  create a StateObject - weatherMapPlaceViewModel and inject it as an environmentObject.
    
    @StateObject private var ViewModel = WeatherMapPlaceViewModel()

    var body: some Scene {
        WindowGroup {
            NavBarView()
                .environmentObject(ViewModel)

        // MARK:  Create a database to store locations using SwiftData
                .modelContainer(for: [LocationModel.self])
            
            
        }
        
    }
}
