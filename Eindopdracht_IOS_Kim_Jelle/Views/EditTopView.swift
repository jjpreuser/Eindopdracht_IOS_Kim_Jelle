import SwiftUI
import PhotosUI

struct EditTopView: View {

    @EnvironmentObject var logbookVM: LogbookViewModel
    @Environment(\.dismiss) private var dismiss

    @State var top: TopLog
    @State private var showDeleteAlert = false
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var image: UIImage? = nil
    
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
            
            Section("Photo") {
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(10)
                }

                PhotosPicker(
                    selection: $selectedPhoto,
                        matching: .images,
                        photoLibrary: .shared()) {
                            Text(image == nil ? "Add Photo" : "Change Photo")
                        }
                        .onChange(of: selectedPhoto) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    image = uiImage
                                }
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
                Task {
                    await logbookVM.delete(top: top)
                    dismiss()
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone.")
        }
    }
}
