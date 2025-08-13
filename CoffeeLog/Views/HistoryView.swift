//
//  HistoryView.swift
//  CoffeeLog
//
//  Created by Dev on 10/08/25.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var vm: CoffeeLogViewModel

    var body: some View {
        List {
            if vm.coffees.isEmpty {
                Section {
                    VStack(spacing: 8) {
                        Image(systemName: "tray")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                        Text("No entries yet")
                            .font(.headline)
                        Text("Add your first coffee in the Logs tab.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                }
            } else {
                Section {
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

                            HStack(spacing: 12) {
                                if let origin = coffee.origin, !origin.isEmpty {
                                    HStack(spacing: 4) {
                                        Image(systemName: "globe.asia.australia")
                                        Text(origin)
                                    }
                                }
                                if let ctype = coffee.coffeeType, !ctype.isEmpty {
                                    HStack(spacing: 4) {
                                        Image(systemName: "leaf")
                                        Text(ctype)
                                    }
                                }
                                if let altitude = coffee.altitudeMeters {
                                    HStack(spacing: 4) {
                                        Image(systemName: "arrow.up.and.down")
                                        Text("\(altitude)m")
                                    }
                                }
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
        .navigationTitle("History")
        .toolbar { ToolbarItem(placement: .topBarTrailing) { EditButton() } }
    }
}


