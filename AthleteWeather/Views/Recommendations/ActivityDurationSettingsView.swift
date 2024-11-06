//
//  ActivitySettingsView.swift
//  AthleteWeather
//
//  Created by Tomáš Dušek on 02.11.2024.
//

import SwiftUI

struct ActivityDurationSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedHours: Int
    @Binding var selectedMinutes: Int
    
    var body: some View {
        HStack {
            Spacer()
            Picker("Select hours", selection: $selectedHours) {
                ForEach(0...200, id: \.self) { number in
                    Text("\(number)")
                }
            }
            .pickerStyle(.wheel)
            .frame(width: 100, height: 150)
            Text("hr")
            
            Picker("Select minutes", selection: $selectedMinutes) {
                ForEach(0...5, id: \.self) { number in
                    Text("\(number*10)")
                }
            }
            .pickerStyle(.wheel)
            .frame(width: 100, height: 150)
            Text("min")
            Spacer()
        }
        Button {
            dismiss()
        } label: {
            Text("Recommend")
                .foregroundColor(.primary)
                .padding()
                .frame(maxWidth: 150)
                .background(Color.primary.opacity(0.1))
                .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle()) // Ensures no additional button styling
        }
                    
    }


#Preview {
    @Previewable @State var hours = 1
    @Previewable @State var minutes = 3
    ActivityDurationSettingsView(selectedHours: $hours, selectedMinutes: $minutes)
}
