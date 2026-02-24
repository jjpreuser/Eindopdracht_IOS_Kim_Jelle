import UIKit

final class ImageStorageService {
    
    static let shared = ImageStorageService()
    
    private init() {}
    
    func saveImage(_ image: UIImage, with fileName: String) throws {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        try data.write(to: url)
    }
    
    func loadImage(fileName: String) -> UIImage? {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        return UIImage(contentsOfFile: url.path)
    }
    
    func deleteImage(fileName: String) throws {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(at: url)
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
