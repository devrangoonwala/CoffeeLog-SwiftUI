//
//  CoffeeRatioCalculatorView.swift
//  CoffeeLog
//
//  Created by Dev on 10/08/25.
//

import SwiftUI

struct CoffeeRatioCalculatorView: View {
    @State private var coffeeWeight = 15.0
    @State private var waterWeight = 250.0
    @State private var selectedRatio = 16.67
    @State private var showingScale = false
    @State private var currentWeight = 0.0
    @State private var targetWeight = 250.0
    @State private var isTaring = false
    
    private let commonRatios = [
        ("Espresso", 2.0),
        ("Ristretto", 1.5),
        ("Lungo", 3.0),
        ("Pour Over", 16.67),
        ("French Press", 15.0),
        ("AeroPress", 17.0),
        ("Chemex", 16.0),
        ("V60", 16.67),
        ("Kalita Wave", 16.0),
        ("Clever Dripper", 15.0)
    ]
    
    var calculatedRatio: Double {
        guard coffeeWeight > 0 else { return 0 }
        return waterWeight / coffeeWeight
    }
    
    var body: some View {
        List {
            Section("Coffee Ratio Calculator") {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Coffee Weight")
                        Spacer()
                        Text("\(coffeeWeight, specifier: "%.1f") g")
                            .monospacedDigit()
                            .foregroundStyle(.secondary)
                    }
                    Slider(value: $coffeeWeight, in: 5...50, step: 0.5)
                    
                    HStack {
                        Text("Water Weight")
                        Spacer()
                        Text("\(waterWeight, specifier: "%.0f") g")
                            .monospacedDigit()
                            .foregroundStyle(.secondary)
                    }
                    Slider(value: $waterWeight, in: 50...1000, step: 10)
                    
                    Divider()
                    
                    HStack {
                        Text("Ratio")
                        Spacer()
                        Text("1:\(calculatedRatio, specifier: "%.1f")")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)
                    }
                    
                    HStack {
                        Text("Total Brew")
                        Spacer()
                        Text("\(coffeeWeight + waterWeight, specifier: "%.0f") g")
                            .monospacedDigit()
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            Section("Common Ratios") {
                ForEach(commonRatios, id: \.0) { name, ratio in
                    Button {
                        selectedRatio = ratio
                        waterWeight = coffeeWeight * ratio
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(name)
                                    .fontWeight(.medium)
                                Text("1:\(ratio, specifier: "%.1f")")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            if abs(calculatedRatio - ratio) < 0.1 {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Section("Digital Scale") {
                VStack(spacing: 16) {
                    HStack {
                        Text("Target Weight")
                        Spacer()
                        Text("\(targetWeight, specifier: "%.0f") g")
                            .monospacedDigit()
                            .foregroundStyle(.secondary)
                    }
                    Slider(value: $targetWeight, in: 50...500, step: 10)
                    
                    Button {
                        showingScale.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "scalemass")
                            Text("Open Digital Scale")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Ratio Calculator")
        .sheet(isPresented: $showingScale) {
            DigitalScaleView(currentWeight: $currentWeight, targetWeight: targetWeight, isTaring: $isTaring)
        }
    }
}

struct DigitalScaleView: View {
    @Binding var currentWeight: Double
    @State var targetWeight: Double
    @Binding var isTaring: Bool
    @Environment(\.dismiss) private var dismiss
    
    @State private var timer: Timer?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Spacer()
                
                // Weight display
                VStack(spacing: 8) {
                    Text("\(currentWeight, specifier: "%.1f")")
                        .font(.system(size: 72, weight: .thin, design: .monospaced))
                        .foregroundStyle(isTaring ? .orange : .primary)
                    
                    Text("grams")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
                
                // Target indicator
                if !isTaring {
                    VStack(spacing: 4) {
                        Text("Target: \(targetWeight, specifier: "%.0f") g")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        
                        // Progress bar
                        ProgressView(value: min(currentWeight / targetWeight, 1.0))
                            .progressViewStyle(.linear)
                            .frame(width: 200)
                    }
                }
                
                Spacer()
                
                // Control buttons
                HStack(spacing: 40) {
                    Button {
                        isTaring.toggle()
                        if isTaring {
                            currentWeight = 0
                        }
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: isTaring ? "scalemass.fill" : "scalemass")
                                .font(.title)
                            Text(isTaring ? "Taring..." : "Tare")
                                .font(.caption)
                        }
                    }
                    .buttonStyle(.bordered)
                    .foregroundStyle(isTaring ? .orange : .primary)
                    
                    Button {
                        // Simulate adding weight
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentWeight += Double.random(in: 5...25)
                        }
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: "plus.circle")
                                .font(.title)
                            Text("Add Weight")
                                .font(.caption)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(isTaring)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Digital Scale")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            startSimulation()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func startSimulation() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if !isTaring && currentWeight < targetWeight {
                withAnimation(.easeInOut(duration: 0.1)) {
                    currentWeight += Double.random(in: 0.1...0.5)
                }
            }
        }
    }
}
