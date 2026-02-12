//
//  BoulderListView.swift
//  Eindopdracht_IOS_Kim_Jelle
//
//  Created by Jelle Reuser on 12/02/2026.
//

import SwiftUI

struct BoulderListView: View {
    let area: Area
    @EnvironmentObject var logbookVM: LogbookViewModel
    @StateObject private var viewModel = BoulderViewModel()

    var body: some View {
        List {
            if viewModel.isLoading && viewModel.boulders.isEmpty {
                HStack {
                    ProgressView()
                    Text("Loading boulders…")
                }
            }

            ForEach(viewModel.boulders) { boulder in
                NavigationLink {
                    BoulderDetailView(boulder: boulder)
                        .environmentObject(logbookVM)
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(boulder.name)
                            .font(.headline)

                        HStack(spacing: 12) {
                            if let v = boulder.grades?.vscale, !v.isEmpty {
                                Label(v, systemImage: "bolt.fill")
                                    .foregroundStyle(.secondary)
                            }

                            if let type = boulder.type, !type.isEmpty {
                                Text(type.capitalized)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .font(.subheadline)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle(area.area_name)
        .task {
            await viewModel.load(areaId: area.uuid)
        }
    }
}


#Preview {
    NavigationStack {
        BoulderListView(area: Area(uuid: "demo", area_name: "Demo Area", metadata: .init(lat: 52.0, lng: 5.0)))
    }
}
