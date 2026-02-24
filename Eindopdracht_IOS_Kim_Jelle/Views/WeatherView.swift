import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()

    var body: some View {
        VStack {
            // Search bar
            HStack {
                TextField("Search city or coordinates", text: $viewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit {
                        viewModel.loadWeather()
                    }

                Button("Search") {
                    viewModel.loadWeather()
                }
                .buttonStyle(.bordered)
            }
            .padding()

            // Loading state
            if viewModel.isLoading {
                ProgressView("Loading weather…")
                    .padding()
            }

            // Error state
            if let error = viewModel.error {
                VStack(spacing: 8) {
                    Text("Error")
                        .font(.headline)
                    Text(error)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                    Button("Retry") {
                        viewModel.loadWeather()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }

            // Weather content
            if let weather = viewModel.weather {
                List {
                    // Current weather
                    if weather.liveweer.isEmpty {
                        ContentUnavailableView(
                            "No results",
                            systemImage: "magnifyingglass",
                            description: Text("Try a different city name.")
                        )
                    } else {
                        Section("Current") {
                            ForEach(weather.liveweer) { item in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.plaats)
                                        .font(.headline)
                                    Text(item.samenv)
                                        .font(.subheadline)
                                    HStack {
                                        Text("Temp: \(String(format: "%.1f", item.temp))°C")
                                        Text("Feels like: \(String(format: "%.1f", item.gtemp))°C")
                                    }
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }

                    // Weekly forecast
                    if !weather.wk_verw.isEmpty {
                        Section("This Week") {
                            ForEach(weather.wk_verw) { day in
                                HStack {
                                    Text(day.dag)
                                    Spacer()
                                    Text("Min \(Int(day.min_temp))°  Max \(Int(day.max_temp))°")
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }

                    // Hourly forecast
                    if !weather.uur_verw.isEmpty {
                        Section("Hourly") {
                            ForEach(weather.uur_verw) { hour in
                                HStack {
                                    Text(hour.uur)
                                    Spacer()
                                    Text("\(Int(hour.temp))°  Wind \(hour.windbft) bft")
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            } else if !viewModel.isLoading && viewModel.error == nil {
                // Initial empty state
                ContentUnavailableView(
                    "Weather",
                    systemImage: "cloud.sun",
                    description: Text("Fetch the latest weather forecast by entering a city or coordinates above.")
                )
            }
        }
        .navigationTitle("Weather")
    }
}

#Preview {
    NavigationStack {
        WeatherView()
    }
}
