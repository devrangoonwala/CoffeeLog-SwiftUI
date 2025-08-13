//
//  CoffeeLogView.swift
//  CoffeeLog
//
//  Created by Dev on 10/08/25.
//

import SwiftUI

struct CoffeeLogView: View {
    @StateObject private var vm = CoffeeLogViewModel()

    // Inline composer state (single-screen UX)
    @State private var showComposer = false
    @State private var showAdvanced = false
    @State private var type = "" // coffee name
    @State private var brewMethod = ""
    @State private var rating = 3
    @State private var gramsUsed = 15.0
    @State private var pourTimeSeconds = 30
    @State private var notes = ""
    @State private var origin = ""
    @State private var coffeeType = "" // e.g., Arabica/Robusta
    @State private var altitude = "" // meters

    var body: some View {
        List {
            // Composer section
            Section {
                if showComposer {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            TextField("Coffee name", text: $type)
                                .textInputAutocapitalization(.words)
                                .autocorrectionDisabled()
                            Button(role: .cancel) {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                    resetComposer()
                                    showComposer = false
                                }
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.secondary)
                            }
                            .buttonStyle(.plain)
                        }

                        TextField("Brew method", text: $brewMethod)
                            .textInputAutocapitalization(.words)
                            .autocorrectionDisabled()

                        // Compact rating control
                        HStack(spacing: 8) {
                            Text("Rating")
                            Spacer()
                            Picker("Rating", selection: $rating) {
                                ForEach(1...5, id: \.self) { value in
                                    Image(systemName: value <= rating ? "star.fill" : "star")
                                        .tag(value)
                                }
                            }
                            .pickerStyle(.segmented)
                            .frame(maxWidth: 220)
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            // Beans amount
                            HStack {
                                Text("Beans")
                                Spacer()
                                Text("\(gramsUsed, specifier: "%.1f") g")
                                    .monospacedDigit()
                                    .foregroundStyle(.secondary)
                            }
                            Slider(value: $gramsUsed, in: 5...40, step: 0.5)

                            // Pour time
                            HStack {
                                Text("Pour time")
                                Spacer()
                                Text("\(pourTimeSeconds) s")
                                    .monospacedDigit()
                                    .foregroundStyle(.secondary)
                            }
                            Slider(value: $pourTimeSeconds.doubleBinding(), in: 5...300, step: 5)

                            // New fields
                            TextField("Origin (e.g., Ethiopia)", text: $origin)
                                .textInputAutocapitalization(.words)
                                .autocorrectionDisabled()
                            TextField("Type of coffee (e.g., Arabica)", text: $coffeeType)
                                .textInputAutocapitalization(.words)
                                .autocorrectionDisabled()
                            TextField("Altitude (m)", text: $altitude)
                                .keyboardType(.numberPad)

                            TextField("Notes", text: $notes, axis: .vertical)
                                .lineLimit(1...3)
                        }
                        .transition(.opacity.combined(with: .scale))

                        Button {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                addCoffee()
                            }
                        } label: {
                            Text("Save")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(type.isEmpty || brewMethod.isEmpty)
                    }
                    .padding(.vertical, 4)
                    .transition(.asymmetric(insertion: .move(edge: .top).combined(with: .opacity),
                                            removal: .scale.combined(with: .opacity)))
                } else {
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            showComposer = true
                        }
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                            Text("Add coffee entry")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .buttonStyle(.plain)
                    .contentShape(Rectangle())
                }
            }

            if !vm.coffees.isEmpty {
                Section("History") {
                    ForEach(vm.coffees) { coffee in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(coffee.type)
                                    .font(.headline)
                                Text("•")
                                    .foregroundStyle(.secondary)
                                Text(coffee.brewMethod)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }

                            Text("Rating: \(coffee.rating) | \(coffee.gramsUsed, specifier: "%.1f") g | \(coffee.pourTimeSeconds) s")
                                .font(.footnote)
                                .foregroundStyle(.secondary)

                            // New optional info row
                            HStack(spacing: 8) {
                                if let origin = coffee.origin, !origin.isEmpty {
                                    Label(origin, systemImage: "globe.asia.australia")
                                }
                                if let ctype = coffee.coffeeType, !ctype.isEmpty {
                                    Label(ctype, systemImage: "leaf")
                                }
                                if let altitude = coffee.altitudeMeters {
                                    Label("\(altitude)m", systemImage: "arrow.up.and.down")
                                }
                            }
                            .labelStyle(.iconOnly)
                            .font(.caption)
                            .foregroundStyle(.secondary)

                            if let notes = coffee.notes, !notes.isEmpty {
                                Text(notes)
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }

                            Text(coffee.date.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        .contentShape(Rectangle())
                    }
                    .onDelete(perform: vm.removeCoffees)
                }
            }
        }
        .listStyle(.insetGrouped)
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: showComposer)
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: showAdvanced)
        .navigationTitle("Coffee Log")
        .toolbar { ToolbarItem(placement: .topBarLeading) { EditButton() } }
        .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 0) }
    }
}

private extension Binding where Value == Int {
    func doubleBinding() -> Binding<Double> {
        Binding<Double>(
            get: { Double(wrappedValue) },
            set: { wrappedValue = Int($0) }
        )
    }
}

private extension CoffeeLogView {
    func addCoffee() {
        let altitudeInt = Int(altitude)
        vm.addCoffee(
            type: type,
            brewMethod: brewMethod,
            rating: rating,
            gramsUsed: gramsUsed,
            pourTimeSeconds: pourTimeSeconds,
            stopTime: nil,
            notes: notes.isEmpty ? nil : notes,
            origin: origin.isEmpty ? nil : origin,
            coffeeType: coffeeType.isEmpty ? nil : coffeeType,
            altitudeMeters: altitudeInt
        )
        resetComposer()
        showComposer = false
    }

    func resetComposer() {
        type = ""
        brewMethod = ""
        rating = 3
        gramsUsed = 15.0
        pourTimeSeconds = 30
        notes = ""
        origin = ""
        coffeeType = ""
        altitude = ""
        showAdvanced = false
    }
}
