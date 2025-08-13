//
//  CoffeeEntry.swift
//  CoffeeLog
//
//  Created by Dev on 10/08/25.
//

import Foundation

struct CoffeeEntry: Identifiable, Codable {
    let id: UUID
    let date: Date
    var type: String
    var brewMethod: String
    var rating: Int
    var gramsUsed: Double
    var pourTimeSeconds: Int
    var stopTime: Date?
    var notes: String?
    var origin: String?
    var coffeeType: String?
    var altitudeMeters: Int?
    
    init(
        type: String,
        brewMethod: String,
        rating: Int,
        gramsUsed: Double,
        pourTimeSeconds: Int,
        stopTime: Date? = nil,
        notes: String? = nil,
        origin: String? = nil,
        coffeeType: String? = nil,
        altitudeMeters: Int? = nil
    ) {
        self.id = UUID()
        self.date = Date()
        self.type = type
        self.brewMethod = brewMethod
        self.rating = rating
        self.gramsUsed = gramsUsed
        self.pourTimeSeconds = pourTimeSeconds
        self.stopTime = stopTime
        self.notes = notes
        self.origin = origin
        self.coffeeType = coffeeType
        self.altitudeMeters = altitudeMeters
    }
}

