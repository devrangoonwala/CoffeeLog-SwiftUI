//
//  CoffeeLogApp.swift
//  CoffeeLog
//
//  Created by Dev on 10/08/25.
//

import SwiftUI

@main
struct CoffeeLogApp: App {
    @StateObject private var vm = CoffeeLogViewModel()
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack { CoffeeLogView() }
                    .tabItem {
                        Label("Logs", systemImage: "cup.and.saucer")
                    }

                NavigationStack { HistoryView() }
                    .tabItem {
                        Label("History", systemImage: "clock")
                    }
                
                NavigationStack { CoffeeRatioCalculatorView() }
                    .tabItem {
                        Label("Calculator", systemImage: "scalemass")
                    }
            }
            .environmentObject(vm)
        }
    }
}
