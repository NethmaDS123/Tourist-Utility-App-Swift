import SwiftUI

struct HourlyWeatherView: View {
    @EnvironmentObject var weatherMapPlaceViewModel: WeatherMapPlaceViewModel

    var body: some View {
        VStack {
            Text("Hourly Forecast Weather for \(weatherMapPlaceViewModel.newLocation)")
                .font(.title3)
                .padding()
                

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    if let hourlyData = weatherMapPlaceViewModel.weatherDataModel?.hourly, !hourlyData.isEmpty {
                        ForEach(hourlyData.prefix(24), id: \.dt) { hour in
                            VStack(spacing: 8) {
                                // Time
                                Text(DateFormatterUtils.formattedDate(from: hour.dt, format: "hh a"))
                                    .font(.subheadline)
                                    .fontWeight(.medium)

                                // Weather Icon
                                if let iconCode = hour.weather.first?.icon {
                                    AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(iconCode)@2x.png")) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 40)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }

                                // Temperature
                                Text("\(Int(hour.temp))°C")
                                    .font(.headline)

                                // Weather Description
                                Text(hour.weather.first?.weatherDescription.capitalized ?? "N/A")
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                            .frame(width: 100)
                            .frame(height: 190)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(10)
                        }
                    } else {
                        Text("No hourly data available")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    HourlyWeatherView()
        .environmentObject(WeatherMapPlaceViewModel())
}

