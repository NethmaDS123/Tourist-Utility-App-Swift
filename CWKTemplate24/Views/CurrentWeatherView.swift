//
//  CurrentWeatherView.swift
//  CWKTemplate24
//
//  Created by girish lukka on 23/10/2024.
//

import SwiftUI
 
struct CurrentWeatherView: View {
    
    // MARK:  set up the @EnvironmentObject for WeatherMapPlaceViewModel
    @EnvironmentObject var weatherMapPlaceViewModel: WeatherMapPlaceViewModel
    
    // MARK:  set up local @State variable to support this view
    var body: some View {
        ZStack{
            // Sky Background
            Image("sky")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 20){
                //Header
                VStack {
                    Text(weatherMapPlaceViewModel.newLocation)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(DateFormatterUtils.formattedDateWithStyle(from: Int(Date().timeIntervalSince1970), style: .medium))
                        .font(.headline)
                        .foregroundColor(.black)
                }
                //Weather information
                VStack(spacing: 20) {
                    Text(weatherMapPlaceViewModel.weatherDataModel?.current.weather.first?.weatherDescription.capitalized ?? "Loading...")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    
                    Text("Feels like: \(Int(weatherMapPlaceViewModel.weatherDataModel?.current.feelsLike ?? 0)) ℃")
                        .font(.title2)
                        .foregroundColor(.black)
                    
                    HStack {
                        HStack(spacing: 10)  {
                            Image("temperature")
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text("H: \(Int(weatherMapPlaceViewModel.weatherDataModel?.daily.first?.temp.max ?? 0)) ℃")
                                .font(.title2)
                        }
                        
                        HStack(spacing: 10) {
                            
                            Text("L: \(Int(weatherMapPlaceViewModel.weatherDataModel?.daily.first?.temp.min ?? 0)) ℃")
                                .font(.title2)
                        }
                    }
                    VStack(spacing: 20) {
                        HStack {
                            Image("windSpeed")
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text("Wind Speed: \(Int(weatherMapPlaceViewModel.weatherDataModel?.current.windSpeed ?? 0)) m/s")
                                .font(.title2)
                        }
                        
                        HStack {
                            Image("humidity")
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text("Humidity: \(Int(weatherMapPlaceViewModel.weatherDataModel?.current.humidity ?? 0))%")
                                .font(.title2)
                        }
                        
                        HStack {
                            Image("pressure")
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text("Pressure: \(Int(weatherMapPlaceViewModel.weatherDataModel?.current.pressure ?? 0)) hPa")
                                .font(.title2)
                        }
                    }
                }
                .padding()
                
                // MARK: - Air Quality Section
                VStack {
                    Text("Current Air Quality in \(weatherMapPlaceViewModel.newLocation)")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 20) {
                        if let airComponents = weatherMapPlaceViewModel.airDataModel?.list.first?.components {
                            VStack {
                                Image("so2")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 70, height: 60)
                                    .clipped()
                                Text("\(String(format: "%.2f", airComponents.so2))")
                                    .fontWeight(.medium)
                            }
                            VStack {
                                Image("no")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 70, height: 60)
                                    .clipped()
                                Text("\(String(format: "%.2f", airComponents.no2))")
                                    .fontWeight(.medium)
                            }
                            VStack {
                                Image("voc")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 70, height: 60)
                                    .clipped()
                                Text("\(String(format: "%.2f", airComponents.co))")
                                    .fontWeight(.medium)
                            }
                            VStack {
                                Image("pm")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 70, height: 60)
                                    .clipped()
                                Text("\(String(format: "%.2f", airComponents.pm10))")
                                    .fontWeight(.medium)
                            }
                        } else {
                            // Fallback in case of no data
                            Text("No air quality data available")
                                .font(.footnote)
                        }
                    }
                    .padding()
                    .background(
                        Image("BG") 
                            .resizable()
                            .scaledToFill()
                    )
                    .frame(height: 105)
                    .clipped()
                }
                .padding(.top, 20)
                
                
                Spacer()
            }
            .frame(height: 600)
            
        }
            
        }
    }


#Preview {
    CurrentWeatherView()
        .environmentObject(WeatherMapPlaceViewModel())
}
