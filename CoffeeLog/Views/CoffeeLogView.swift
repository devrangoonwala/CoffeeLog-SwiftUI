//
//  CoffeeLogView.swift
//  CoffeeLog
//
//  Created by Dev on 10/08/25.
//

import SwiftUI

struct CoffeeLogView: View {
    @StateObject private var vm = CoffeeLogViewModel()

    @State private var showingAdd = false

    var body: some View {
        List {
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
        .navigationTitle("Coffee Log")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) { EditButton() }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingAdd = true
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("Add Coffee")
            }
        }
        .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 0) }
        .sheet(isPresented: $showingAdd) {
            AddCoffeeView { type, method, rating, grams, seconds, stop, notes in
                vm.addCoffee(type: type, brewMethod: method, rating: rating, gramsUsed: grams, pourTimeSeconds: seconds, stopTime: stop, notes: notes)
            }
            .presentationDetents([.medium, .large])
        }
    }
}
