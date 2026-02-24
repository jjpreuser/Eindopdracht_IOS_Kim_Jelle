import SwiftUI
import PhotosUI

struct EditTopView: View {
    @EnvironmentObject var logbookVM: LogbookViewModel
    @Environment(\.dismiss) private var dismiss

    @State var top: TopLog
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var image: UIImage? = nil
    @State private var showDeleteAlert = false

    init(top: TopLog) {
        self._top = State(initialValue: top)
        if let fileName = top.photoFileName,
           let uiImage = ImageStorageService.shared.loadImage(fileName: fileName) {
            self._image = State(initialValue: uiImage)
        }
    }

    var body: some View {
        Form {
            Section("Boulder") {
                Text(top.boulderName)
                Text("Grade: \(top.grade)").foregroundColor(.secondary)
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
                Button("Save Changes") {
                    Task {
                        await logbookVM.update(top: top, image: image)
                        dismiss()
                    }
                }
                .buttonStyle(.borderedProminent)
            }

            Section {
                Button("Delete Top") {
                    showDeleteAlert = true
                }
                .foregroundColor(.red)
            }
        }
        .navigationTitle("Edit Top")
        .alert("Delete this top?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                Task { await logbookVM.delete(top: top); dismiss() }
            }
            Button("Cancel", role: .cancel) {}
        }
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
