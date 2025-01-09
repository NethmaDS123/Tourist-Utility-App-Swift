//
//  ForecastWeatherView.swift
//  CWKTemplate24
//
//  Created by girish lukka on 23/10/2024.
//

import SwiftUI

struct ForecastWeatherView: View {

    // MARK:  set up the @EnvironmentObject for WeatherMapPlaceViewModel
        @EnvironmentObject var weatherMapPlaceViewModel: WeatherMapPlaceViewModel


    var body: some View {
        ZStack {
            // Sky Background
            Image("sky")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                HourlyWeatherView()
                    .frame(height: 250)
                    .padding(.top, 100)
                
                DailyWeatherView()
                    .padding(.top, 3)
            }
        }
    }
}

#Preview {
    ForecastWeatherView()
        .environmentObject(WeatherMapPlaceViewModel())
}
