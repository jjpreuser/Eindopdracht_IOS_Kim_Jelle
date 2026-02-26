import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()

    var body: some View {
        List {
            Section("Search") {
                HStack(spacing: 8) {
                    TextField("City or coordinates", text: $viewModel.searchText)
                        .textInputAutocapitalization(.words)
                        .disableAutocorrection(true)
                        .onSubmit { viewModel.loadWeather() }

                    Button {
                        viewModel.loadWeather()
                    } label: {
                        Label("Search", systemImage: "magnifyingglass")
                            .labelStyle(.iconOnly)
                    }
                    .buttonStyle(.bordered)
                }
            }
            if viewModel.isLoading {
                Section {
                    ContentUnavailableView(
                        "Loading weather…",
                        systemImage: "hourglass",
                        description: Text("Fetching the latest forecast.")
                    )
                }
            } else if let error = viewModel.error {
                Section {
                    VStack(spacing: 8) {
                        ContentUnavailableView(
                            "Error",
                            systemImage: "exclamationmark.triangle",
                            description: Text(error)
                        )
                        Button {
                            viewModel.loadWeather()
                        } label: {
                            Label("Retry", systemImage: "arrow.clockwise")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 8)
                }
            } else if viewModel.weather == nil {
                Section {
                    ContentUnavailableView(
                        "Weather",
                        systemImage: "cloud.sun",
                        description: Text("Enter a city or coordinates above to fetch the forecast.")
                    )
                }
            }

            if let weather = viewModel.weather {
                if weather.liveweer.isEmpty {
                    Section("Current") {
                        ContentUnavailableView(
                            "No results",
                            systemImage: "magnifyingglass",
                            description: Text("Try a different city name.")
                        )
                    }
                } else {
                    Section("Current") {
                        ForEach(weather.liveweer) { item in
                            HStack(alignment: .center, spacing: 12) {
                                Image(systemName: systemImageName(for: item.image))
                                    .font(.title2)
                                    .foregroundStyle(.blue)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.plaats)
                                        .font(.headline)
                                    Text(item.samenv)
                                        .font(.subheadline)

                                    HStack(spacing: 12) {
                                        Text("\(String(format: "%.1f", item.temp))°C")
                                        Text("Feels \(String(format: "%.1f", item.gtemp))°C")
                                            .foregroundStyle(.secondary)
                                    }
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                }

                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }

                if !weather.wk_verw.isEmpty {
                    Section("This Week") {
                        ForEach(weather.wk_verw) { day in
                            HStack(spacing: 12) {
                                Image(systemName: systemImageName(for: day.image))
                                    .foregroundStyle(.orange)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(day.dag)
                                        .font(.headline)
                                    Text("Wind \(day.windbft) bft • \(day.windr)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Text("Min \(day.min_temp)°  Max \(day.max_temp)°")
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }

                if !weather.uur_verw.isEmpty {
                    Section("Hourly") {
                        ForEach(weather.uur_verw) { hour in
                            HStack(spacing: 12) {
                                Image(systemName: systemImageName(for: hour.image))
                                    .foregroundStyle(.teal)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(formattedHour(hour.uur))
                                        .font(.headline)
                                    Text("Wind \(hour.windbft) bft • \(hour.windr)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Text("\(hour.temp)°")
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Weather")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.loadWeather()
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .disabled(viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
    }

    private func formattedHour(_ uur: String) -> String {
        if let idx = uur.lastIndex(of: " ") {
            return String(uur[uur.index(after: idx)...])
        }
        if let idx = uur.lastIndex(of: "T") {
            return String(uur[uur.index(after: idx)...])
        }
        return uur
    }

    private func systemImageName(for code: String) -> String {
        let lower = code.lowercased()
        if lower.contains("sun") { return "sun.max.fill" }
        if lower.contains("cloud") { return "cloud.fill" }
        if lower.contains("rain") { return "cloud.rain.fill" }
        if lower.contains("snow") { return "cloud.snow.fill" }
        if lower.contains("storm") || lower.contains("thunder") { return "cloud.bolt.rain.fill" }
        if lower.contains("fog") || lower.contains("mist") { return "cloud.fog.fill" }
        if lower.contains("wind") { return "wind" }
        return "cloud.sun.fill"
    }
}

#Preview {
    NavigationStack {
        WeatherView()
    }
}
