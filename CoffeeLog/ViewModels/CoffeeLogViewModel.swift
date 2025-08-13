//
//  CoffeeLogViewModel.swift
//  CoffeeLog
//
//  Created by Dev on 10/08/25.
//

import SwiftUI

class CoffeeLogViewModel: ObservableObject {
    @Published var coffees: [CoffeeEntry] = [] {
        didSet { saveCoffees() } // Save automatically when changed
    }
    
    private let savePath = FileManager.documentsDirectory.appendingPathComponent("coffees.json")
    
    init() {
        loadCoffees()
    }
    
    func removeCoffees(at offsets: IndexSet) {
        coffees.remove(atOffsets: offsets)
    }

    func addCoffee(
        type: String,
        brewMethod: String,
        rating: Int,
        gramsUsed: Double,
        pourTimeSeconds: Int,
        stopTime: Date? = nil,
        notes: String?,
        origin: String? = nil,
        coffeeType: String? = nil,
        altitudeMeters: Int? = nil
    ) {
        let newCoffee = CoffeeEntry(
            type: type,
            brewMethod: brewMethod,
            rating: rating,
            gramsUsed: gramsUsed,
            pourTimeSeconds: pourTimeSeconds,
            stopTime: stopTime,
            notes: notes,
            origin: origin,
            coffeeType: coffeeType,
            altitudeMeters: altitudeMeters
        )
        coffees.insert(newCoffee, at: 0)
    }
    
    private func saveCoffees() {
        do {
            let data = try JSONEncoder().encode(coffees)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("❌ Failed to save coffees: \(error.localizedDescription)")
        }
    }
    
    private func loadCoffees() {
        do {
            let data = try Data(contentsOf: savePath)
            coffees = try JSONDecoder().decode([CoffeeEntry].self, from: data)
        } catch {
            coffees = [] // Start empty if no file
        }
    }
}
