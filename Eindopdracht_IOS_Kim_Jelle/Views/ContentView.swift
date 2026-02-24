//
//  ContentView.swift
//  Eindopdracht_IOS_Kim_Jelle
//
//  Created by Jelle Reuser on 12/02/2026.
//

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
                WeatherView()
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
