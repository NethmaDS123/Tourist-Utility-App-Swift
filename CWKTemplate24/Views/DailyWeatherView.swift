import SwiftUI

struct DailyWeatherView: View {
    @EnvironmentObject var weatherMapPlaceViewModel: WeatherMapPlaceViewModel

    var body: some View {
        VStack {
            Text("8 Day Forecast Weather for \(weatherMapPlaceViewModel.newLocation)")
                .font(.title3)
                .padding()

            ScrollView {
                VStack(spacing: 15) {
                    if let dailyData = weatherMapPlaceViewModel.weatherDataModel?.daily, !dailyData.isEmpty {
                        ForEach(dailyData, id: \.dt) { day in
                            HStack {
                                Spacer()

                                // Weather Icon
                                if let iconCode = day.weather.first?.icon {
                                    AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(iconCode)@2x.png")) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 40)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }

                                Spacer()

                                // Day and Description
                                VStack {
                                    Text("\(DateFormatterUtils.formattedDate(from: day.dt, format: "EEEE d"))")
                                        .fontWeight(.medium)
                                    Text(day.weather.first?.weatherDescription.capitalized ?? "N/A")
                                        .font(.caption)
                                        .multilineTextAlignment(.center)
                                }

                                Spacer()

                                // Day and Night Temperatures
                                VStack {
                                    HStack {
                                        VStack {
                                            Text("Day")
                                                .fontWeight(.medium)
                                            Text("\(Int(day.temp.day))°C")
                                                .fontWeight(.medium)
                                        }
                                        VStack {
                                            Text("Night")
                                                .fontWeight(.medium)
                                            Text("\(Int(day.temp.night))°C")
                                                .fontWeight(.medium)
                                        }
                                    }
                                }

                                Spacer()
                            }
                            .padding()
                            .background(Color.black.opacity(0.06))
                            .cornerRadius(10)
                            .shadow(radius: 10)
                        }
                    } else {
                        Text("No daily data available")
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
    DailyWeatherView()
        .environmentObject(WeatherMapPlaceViewModel())
}

