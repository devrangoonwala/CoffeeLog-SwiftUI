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
                ContentUnavailableView(
                    "No entries yet",
                    systemImage: "tray",
                    description: Text("Add your first coffee in the Logs tab.")
                )
            } else {
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
        .listStyle(.insetGrouped)
        .navigationTitle("History")
        .toolbar { ToolbarItem(placement: .topBarTrailing) { EditButton() } }
    }
}


