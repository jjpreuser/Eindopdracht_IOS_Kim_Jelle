//
//  AreaListVIew.swift
//  Eindopdracht_IOS_Kim_Jelle
//
//  Created by Jelle Reuser on 12/02/2026.
//

import SwiftUI

struct AreaListView: View {
    @StateObject private var viewModel = AreaViewModel()
    @State private var searchText: String = ""
    @State private var searchTask: Task<Void, Never>?

    var body: some View {
        List {
            if viewModel.isLoading && viewModel.areas.isEmpty {
                HStack {
                    ProgressView()
                    Text("Searching areas…")
                }
            }

            ForEach(viewModel.areas) { area in
                NavigationLink(value: area) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(area.area_name)
                            .font(.headline)
                        if let lat = area.metadata?.lat, let lng = area.metadata?.lng {
                            Text(String(format: "Lat: %.4f, Lng: %.4f", lat, lng))
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("Areas")
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic))
        .onChange(of: searchText) { _, newValue in
            // Debounce simple: cancel previous task and start a new one
            searchTask?.cancel()
            searchTask = Task { [newValue] in
                try? await Task.sleep(nanoseconds: 400_000_000) // 0.4s debounce
                if Task.isCancelled { return }
                await viewModel.search(name: newValue)
            }
        }
        .onDisappear {
            searchTask?.cancel()
        }
        .navigationDestination(for: Area.self) { area in
            BoulderListView(area: area)
        }
    }
}

#Preview {
    NavigationStack {
        AreaListView()
    }
}
