import SwiftUI

struct EditTopView: View {

    @EnvironmentObject var logbookVM: LogbookViewModel
    @Environment(\.dismiss) private var dismiss

    @State var top: TopLog

    var body: some View {
        Form {

            Section("Boulder") {
                Text(top.boulderName)
                Text("Grade: \(top.grade)")
                    .foregroundColor(.secondary)
            }

            Section("Details") {
                DatePicker("Date", selection: $top.date, displayedComponents: .date)

                Stepper("Attempts: \(top.attempts)",
                        value: $top.attempts,
                        in: 1...100)

                Stepper("Rating: \(top.rating)",
                        value: $top.rating,
                        in: 1...5)

                TextField("Notes", text: $top.notes, axis: .vertical)
            }

            Section {
                Button("Save Changes") {
                    Task {
                        await logbookVM.update(top: top)
                        dismiss()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .navigationTitle("Edit Top")
    }
}

