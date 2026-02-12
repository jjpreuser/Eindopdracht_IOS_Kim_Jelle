import SwiftUI

struct AddTopView: View {
    @EnvironmentObject var logbookVM: LogbookViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var top = TopLog(
        id: UUID(), boulderId: "",        boulderName: "",
        grade: "",
        date: Date(),
        attempts: 1,
        rating: 1,
        notes: ""
    )

    var isFormValid: Bool {
        !top.boulderName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !top.grade.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        Form {
            Section(header:
                HStack {
                    Text("Boulder")
                        .font(.headline)
                        .fontWeight(.bold)
                }
            ) {
                TextField("Boulder Name (required)", text: $top.boulderName)
                    .autocapitalization(.words)
                TextField("Grade (required)", text: $top.grade)
                    .autocapitalization(.allCharacters)
                
                if top.boulderName.trimmingCharacters(in: .whitespaces).isEmpty ||
                   top.grade.trimmingCharacters(in: .whitespaces).isEmpty {
                    Text("Please fill in both fields to continue.")
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }

            Section("Details") {
                DatePicker("Date", selection: $top.date, displayedComponents: .date)
                Stepper("Attempts: \(top.attempts)", value: $top.attempts, in: 1...100)
                Stepper("Rating: \(top.rating)", value: $top.rating, in: 1...5)
                TextField("Notes", text: $top.notes, axis: .vertical)
            }

            Section {
                Button("Add Top") {
                    Task {
                        await logbookVM.add(top: top)
                        dismiss()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(!isFormValid) // DISABLE BUTTON if mandatory fields empty
            }
        }
        .navigationTitle("Add Top")
    }
}
