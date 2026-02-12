//
//  LogBookView.swift
//  Eindopdracht_IOS_Kim_Jelle
//
//  Created by Jelle Reuser on 12/02/2026.
//

import SwiftUI

struct LogBookView: View {

    @EnvironmentObject var viewModel: LogbookViewModel

    var body: some View {
        List {
            if viewModel.tops.isEmpty {
                ContentUnavailableView(
                    "No Tops Yet",
                    systemImage: "figure.climbing",
                    description: Text("Start logging your sends!")
                )
            }

            ForEach(viewModel.tops) { top in
                HStack {
                    VStack(alignment: .leading) {
                        Text(top.boulderName)
                            .font(.headline)
                        Text("Grade: \(top.grade)")
                            .font(.subheadline)
                        Text(top.date.formatted(date: .abbreviated, time: .omitted))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: EditTopView(top: top)
                                    .environmentObject(viewModel)) {
                    }
                    .buttonStyle(.borderless) // ensures clean tappable area
                }
                .padding(.vertical, 4)
            }


            .onDelete { offsets in
                Task {
                    await viewModel.delete(at: offsets)
                }
            }
        }
        .navigationTitle("Logbook")
        .toolbar {
            NavigationLink {
                AddTopView()
                    .environmentObject(viewModel)
            } label: {
                Image(systemName: "plus")
            }
        }
    }
}
