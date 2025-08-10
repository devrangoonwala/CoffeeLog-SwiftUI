//
//  CoffeeLogView.swift
//  CoffeeLog
//
//  Created by Dev on 10/08/25.
//

import SwiftUI

struct CoffeeLogView: View {
    @StateObject private var vm = CoffeeLogViewModel()

    @State private var type = ""
    @State private var brewMethod = ""
    @State private var rating = 3
    @State private var gramsUsed = 15.0
    @State private var pourTimeSeconds = 30
    @State private var stopTime = Date()
    @State private var notes = ""

    @FocusState private var focusedField: Field?

    private enum Field: Hashable {
        case type, brewMethod, notes
    }

    var body: some View {
        List {
            Section("Add Coffee") {
                TextField("Coffee type", text: $type)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                    .focused($focusedField, equals: .type)

                TextField("Brew method", text: $brewMethod)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                    .focused($focusedField, equals: .brewMethod)

                Stepper(value: $rating, in: 1...5) {
                    HStack {
                        Text("Rating")
                        Spacer()
                        Text("\(rating)")
                            .monospacedDigit()
                            .foregroundStyle(.secondary)
                    }
                }

                Stepper(value: $gramsUsed, in: 5...40, step: 0.5) {
                    HStack {
                        Text("Beans")
                        Spacer()
                        Text("\(gramsUsed, specifier: "%.1f") g")
                            .monospacedDigit()
                            .foregroundStyle(.secondary)
                    }
                }

                Stepper(value: $pourTimeSeconds, in: 5...300, step: 5) {
                    HStack {
                        Text("Pour time")
                        Spacer()
                        Text("\(pourTimeSeconds) s")
                            .monospacedDigit()
                            .foregroundStyle(.secondary)
                    }
                }

                DatePicker("Stop time", selection: $stopTime, displayedComponents: [.hourAndMinute])

                TextField("Notes", text: $notes, axis: .vertical)
                    .lineLimit(1...3)
                    .focused($focusedField, equals: .notes)

                Button(action: addCoffee) {
                    Text("Add Coffee")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(type.isEmpty || brewMethod.isEmpty)
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

                            HStack(spacing: 8) {
                                Image(systemName: "clock")
                                Text(coffee.stopTime.formatted(date: .omitted, time: .shortened))
                            }
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
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("Coffee Log")
        .toolbar { EditButton() }
        .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 0) }
    }

    private func addCoffee() {
        vm.addCoffee(
            type: type,
            brewMethod: brewMethod,
            rating: rating,
            gramsUsed: gramsUsed,
            pourTimeSeconds: pourTimeSeconds,
            stopTime: stopTime,
            notes: notes.isEmpty ? nil : notes
        )
        type = ""
        brewMethod = ""
        rating = 3
        gramsUsed = 15.0
        pourTimeSeconds = 30
        stopTime = Date()
        notes = ""
        focusedField = nil
    }
}
