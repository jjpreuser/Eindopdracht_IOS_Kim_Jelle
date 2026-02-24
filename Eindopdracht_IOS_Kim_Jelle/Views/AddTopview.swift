import SwiftUI
import PhotosUI

struct AddTopView: View {
    @EnvironmentObject var logbookVM: LogbookViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var image: UIImage? = nil

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
            Section("Boulder") {
                TextField("Boulder Name (required)", text: $top.boulderName)
                    .autocapitalization(.words)
                TextField("Grade (required)", text: $top.grade)
                    .autocapitalization(.allCharacters)
                if !isFormValid {
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

            Section("Photo") {
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 200)
                        .cornerRadius(10)
                }

                PhotosPicker(
                    selection: $selectedPhoto,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Label(image == nil ? "Add Photo" : "Change Photo", systemImage: "photo")
                        .labelStyle(.titleAndIcon)
                }
            }

            if image != nil {
                Section {
                    Button(role: .destructive) {
                        image = nil
                        top.photoFileName = nil
                        selectedPhoto = nil
                    } label: {
                        Label("Remove Photo", systemImage: "trash")
                    }
                }
            }

            Section {
                Button("Add Top") {
                    Task {
                        await logbookVM.add(top: top, image: image)
                        dismiss()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(!isFormValid)
            }
        }
        .navigationTitle("Add Top")
        .onChange(of: selectedPhoto) { _, newItem in
            loadImage(from: newItem)
        }
    }

    private func loadImage(from item: PhotosPickerItem?) {
        guard let item else { return }
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
                let uiImage = UIImage(data: data) {
                await MainActor.run { image = uiImage }
            }
        }
    }
}
