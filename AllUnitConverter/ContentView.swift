//
//  ContentView.swift
//  AllUnitConverter
//
//  Created by Emil Mescheryakov on 25.03.2025.
//

import SwiftUI

struct ContentView: View {

	@State private var inputValue: Double = 0.0
	@State private var inputUnit: Dimension = UnitDuration.hours
	@State private var outputUnit: Dimension = UnitDuration.seconds
	@State private var selectedUnits = 0

	@FocusState private var inputIsFocused: Bool

	let unitTypes = [String(localized:"Temperature"), String(localized:"Time"), String(localized:"Length"), String(localized:"Volume")]

	var units: [[Dimension]] {
		let timeUnits: [UnitDuration] = [.hours, .minutes, .seconds]
		let temperatureUnits: [UnitTemperature] = [.celsius, .fahrenheit, .kelvin]
		let lengthUnits: [UnitLength] = [.meters, .kilometers, .feet, .yards, .miles]
		let volumeUnits: [UnitVolume] = [.milliliters, .liters, .cups, .pints, .gallons]

		return [temperatureUnits, timeUnits, lengthUnits, volumeUnits]
	}

	let formatter: MeasurementFormatter = {
		let formatter = MeasurementFormatter()
		formatter.unitOptions = .providedUnit
		formatter.unitStyle = .short

		return formatter
	}()

	var result: String {
		let output = Measurement(value: inputValue, unit: inputUnit).converted(to: outputUnit)
		return formatter.string(from: output)
	}

	var body: some View {
		NavigationStack{
			Form {
				Section {
					Picker("Select unit type", selection: $selectedUnits) {
						ForEach(0 ..< unitTypes.count, id: \.self) {
							Text(unitTypes[$0])
						}
					}
					.pickerStyle(.menu)
				}

				Section("Convertible value") {
					TextField("Input", value: $inputValue, format: .number)
						.keyboardType(.decimalPad)
						.focused($inputIsFocused)
				}

				Section("Select unit to convert from") {
					Picker("Convert", selection: $inputUnit) {
						ForEach(units[selectedUnits], id: \.self) {
							Text(formatter.string(from: $0).capitalized)
						}
					}
					.pickerStyle(.segmented)
				}

				Section("Select unit to convert to") {
					Picker("Convert to", selection: $outputUnit) {
						ForEach(units[selectedUnits], id: \.self) {
							Text(formatter.string(from: $0).capitalized)
						}
					}
					.pickerStyle(.segmented)
				}

				Section("Result") {
					Text(result)
				}
			}
			.navigationTitle("All Unit Converter")
			.navigationBarTitleDisplayMode(.large)
			.onChange(of: selectedUnits) { _, newUnit in
				inputUnit = units[newUnit][0]
				outputUnit = units[newUnit][1]
			}
			.toolbar {
				if inputIsFocused {
					Button("Done") {
						inputIsFocused = false
					}
				}
			}
		}
	}
}
