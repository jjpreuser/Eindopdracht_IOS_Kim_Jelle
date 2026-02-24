import SwiftUI

struct ContentView: View {

    @StateObject private var logbookVM = LogbookViewModel()

    var body: some View {
        TabView {
            NavigationStack {
                LogBookView()
            }
            .tabItem {
                Label("Logbook", systemImage: "book")
            }
            
            NavigationStack {
                // Weather view
            }
            .tabItem {
                Label("Weather", systemImage: "cloud")
            }
        }
        .environmentObject(logbookVM)
    }
}


#Preview {
    ContentView()
}
