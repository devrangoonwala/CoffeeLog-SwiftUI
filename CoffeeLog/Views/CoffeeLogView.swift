//
//  CoffeeLogView.swift
//  CoffeeLog
//
//  Created by Dev on 10/08/25.
//

import SwiftUI

struct CoffeeLogView: View {
    @EnvironmentObject private var vm: CoffeeLogViewModel
    
    // Form state variables
    @State private var coffeeName = ""
    @State private var brewMethod = ""
    @State private var beansWeight = 15.0
    @State private var waterWeight = 250.0
    @State private var grindSize = "Medium"
    @State private var waterTemperature = 92.0
    @State private var brewTime = 180
    @State private var origin = ""
    @State private var coffeeType = ""
    @State private var altitude = ""
    @State private var roastLevel = "Medium"
    @State private var notes = ""
    
    private let grindSizes = ["Extra Fine", "Fine", "Medium-Fine", "Medium", "Medium-Coarse", "Coarse", "Extra Coarse"]
    private let roastLevels = ["Light", "Medium-Light", "Medium", "Medium-Dark", "Dark", "Very Dark"]

    var body: some View {
        List {
            Section("Coffee Details") {
                TextField("Coffee Name", text: $coffeeName)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                
                TextField("Brew Method", text: $brewMethod)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
            }
            
            Section("Brewing Parameters") {
                HStack {
                    Text("Beans Weight")
                    Spacer()
                    Text("\(beansWeight, specifier: "%.1f") g")
                        .monospacedDigit()
                        .foregroundStyle(.secondary)
                }
                Slider(value: $beansWeight, in: 5...50, step: 0.5)
                
                HStack {
                    Text("Water Weight")
                    Spacer()
                    Text("\(waterWeight, specifier: "%.0f") g")
                        .monospacedDigit()
                        .foregroundStyle(.secondary)
                }
                Slider(value: $waterWeight, in: 100...1000, step: 10)
                
                Picker("Grind Size", selection: $grindSize) {
                    ForEach(grindSizes, id: \.self) { size in
                        Text(size).tag(size)
                    }
                }
                .pickerStyle(.menu)
                
                HStack {
                    Text("Water Temperature")
                    Spacer()
                    Text("\(waterTemperature, specifier: "%.0f")°C")
                        .monospacedDigit()
                        .foregroundStyle(.secondary)
                }
                Slider(value: $waterTemperature, in: 80...100, step: 1)
                
                HStack {
                    Text("Brew Time")
                    Spacer()
                    Text("\(brewTime) seconds")
                        .monospacedDigit()
                        .foregroundStyle(.secondary)
                }
                Slider(value: .constant(Double(brewTime)), in: 30...600, step: 15)
                    .onChange(of: brewTime) { _, newValue in
                        brewTime = Int(newValue)
                    }
            }
            
            Section("Coffee Information") {
                TextField("Origin (e.g., Ethiopia)", text: $origin)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                
                TextField("Coffee Type (e.g., Arabica)", text: $coffeeType)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                
                TextField("Altitude (meters)", text: $altitude)
                    .keyboardType(.numberPad)
                
                Picker("Roast Level", selection: $roastLevel) {
                    ForEach(roastLevels, id: \.self) { level in
                        Text(level).tag(level)
                    }
                }
                .pickerStyle(.menu)
            }
            
            Section("Notes") {
                TextField("Additional notes about this brew...", text: $notes, axis: .vertical)
                    .lineLimit(3...6)
            }
            
            Section {
                Button {
                    saveCoffeeLog()
                } label: {
                    Text("Save Coffee Log")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.semibold)
                }
                .buttonStyle(.borderedProminent)
                .disabled(coffeeName.isEmpty || brewMethod.isEmpty)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Coffee Logs")
        .scrollDismissesKeyboard(.interactively)
    }
    
    private func saveCoffeeLog() {
        let altitudeInt = Int(altitude) ?? 0
        vm.addCoffee(
            type: coffeeName,
            brewMethod: brewMethod,
            rating: 3,
            gramsUsed: beansWeight,
            pourTimeSeconds: brewTime,
            stopTime: nil,
            notes: notes.isEmpty ? nil : notes,
            origin: origin.isEmpty ? nil : origin,
            coffeeType: coffeeType.isEmpty ? nil : coffeeType,
            altitudeMeters: altitudeInt == 0 ? nil : altitudeInt
        )
        resetForm()
    }
    
    private func resetForm() {
        coffeeName = ""
        brewMethod = ""
        beansWeight = 15.0
        waterWeight = 250.0
        grindSize = "Medium"
        waterTemperature = 92.0
        brewTime = 180
        origin = ""
        coffeeType = ""
        altitude = ""
        roastLevel = "Medium"
        notes = ""
    }
}
