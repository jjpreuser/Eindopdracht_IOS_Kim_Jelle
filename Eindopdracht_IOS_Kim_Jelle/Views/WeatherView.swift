import SwiftUI

struct WeatherView: View {
    @StateObject private var vm = KNMIViewModel()
    
    var body: some View {
        VStack {
            if vm.isLoading {
                ProgressView()
            } else if let error = vm.error {
                Text("Error: \(error)")
            } else {
                ScrollView {
                    Text(vm.forecastText)
                        .padding()
                }
            }
        }
        .onAppear {
            vm.loadForecast()
        }
    }
}
