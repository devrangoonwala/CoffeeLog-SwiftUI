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
    var stopTime: Date
    var notes: String?
    
    init(type: String, brewMethod: String, rating: Int, gramsUsed: Double, pourTimeSeconds: Int, stopTime: Date, notes: String? = nil) {
        self.id = UUID()
        self.date = Date()
        self.type = type
        self.brewMethod = brewMethod
        self.rating = rating
        self.gramsUsed = gramsUsed
        self.pourTimeSeconds = pourTimeSeconds
        self.stopTime = stopTime
        self.notes = notes
    }
}

