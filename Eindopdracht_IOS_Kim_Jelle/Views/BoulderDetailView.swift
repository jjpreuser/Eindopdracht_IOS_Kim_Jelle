//
//  BoulderDetailView.swift
//  Eindopdracht_IOS_Kim_Jelle
//
//  Created by Jelle Reuser on 12/02/2026.
//

import SwiftUI

struct BoulderDetailView: View {

    let boulder: Boulder
    @EnvironmentObject var logbookVM: LogbookViewModel

    @State private var attempts: Int = 1
    @State private var rating: Int = 3
    @State private var notes: String = ""
    @State private var showSavedAlert = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                Text(boulder.name)
                    .font(.largeTitle)
                    .bold()

                if let grade = boulder.grades?.vscale {
                    Label("Grade: \(grade)", systemImage: "chart.bar")
                }

                if let type = boulder.type {
                    Label("Type: \(type)", systemImage: "figure.climbing")
                }

                Divider()

                Text("Log this climb")
                    .font(.title2)
                    .bold()

                Stepper("Attempts: \(attempts)", value: $attempts, in: 1...100)

                VStack(alignment: .leading) {
                    Text("Rating")
                    Slider(value: Binding(
                        get: { Double(rating) },
                        set: { rating = Int($0) }
                    ), in: 1...5, step: 1)
                    Text("\(rating) / 5")
                }

                TextField("Notes...", text: $notes, axis: .vertical)
                    .textFieldStyle(.roundedBorder)

                Button("Save Top") {
                    Task {
                        let newTop = TopLog(
                            id: UUID(),
                            boulderId: boulder.uuid,
                            boulderName: boulder.name,
                            grade: boulder.grades?.vscale ?? "-",
                            date: Date(),
                            attempts: attempts,
                            rating: rating,
                            notes: notes
                        )

                        await logbookVM.add(top: newTop)
                        showSavedAlert = true
                    }
                }
                .buttonStyle(.borderedProminent)

            }
            .padding()
        }
        .navigationTitle("Details")
        .alert("Saved to logbook!", isPresented: $showSavedAlert) {
            Button("OK", role: .cancel) {}
        }
    }
}
