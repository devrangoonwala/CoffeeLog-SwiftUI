//
//  AddCoffeeView.swift
//  CoffeeLog
//
//  Created by Dev on 10/08/25.
//

import SwiftUI

struct AddCoffeeView: View {
    @Environment(\.dismiss) private var dismiss

    var onSave: (_ type: String, _ brewMethod: String, _ rating: Int, _ gramsUsed: Double, _ pourTimeSeconds: Int, _ stopTime: Date, _ notes: String?) -> Void

    @State private var type: String = ""
    @State private var brewMethod: String = ""
    @State private var rating: Double = 3
    @State private var gramsUsed: Double = 15
    @State private var pourTimeSeconds: Double = 30
    @State private var stopTime: Date = Date()
    @State private var notes: String = ""
    @State private var showAdvanced: Bool = false

    @FocusState private var focusedField: Field?
    private enum Field { case type, method, notes }

    var body: some View {
        NavigationStack {
            Form {
                Section("Required") {
                    TextField("Coffee type", text: $type)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                        .focused($focusedField, equals: .type)

                    TextField("Brew method", text: $brewMethod)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                        .focused($focusedField, equals: .method)

                    HStack {
                        Text("Rating")
                        Spacer()
                        Text("\(Int(rating))")
                            .monospacedDigit()
                            .foregroundStyle(.secondary)
                    }
                    Slider(value: $rating, in: 1...5, step: 1)
                }

                DisclosureGroup(isExpanded: $showAdvanced) {
                    HStack {
                        Text("Beans")
                        Spacer()
                        Text("\(gramsUsed, specifier: "%.1f") g")
                            .monospacedDigit()
                            .foregroundStyle(.secondary)
                    }
                    Slider(value: $gramsUsed, in: 5...40, step: 0.5)

                    HStack {
                        Text("Pour time")
                        Spacer()
                        Text("\(Int(pourTimeSeconds)) s")
                            .monospacedDigit()
                            .foregroundStyle(.secondary)
                    }
                    Slider(value: $pourTimeSeconds, in: 5...300, step: 5)

                    DatePicker("Stop time", selection: $stopTime, displayedComponents: [.hourAndMinute])

                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(1...3)
                        .focused($focusedField, equals: .notes)
                } label: {
                    Label("Optional details", systemImage: "slider.horizontal.3")
                }
            }
            .navigationTitle("New Coffee")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveAndClose() }
                        .disabled(type.isEmpty || brewMethod.isEmpty)
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") { focusedField = nil }
                }
            }
        }
    }

    private func saveAndClose() {
        onSave(
            type,
            brewMethod,
            Int(rating),
            gramsUsed,
            Int(pourTimeSeconds),
            stopTime,
            notes.isEmpty ? nil : notes
        )
        dismiss()
    }
}


