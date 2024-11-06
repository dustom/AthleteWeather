//
//  ActivitySettingsView.swift
//  AthleteWeather
//
//  Created by Tomáš Dušek on 02.11.2024.
//

import SwiftUI

struct ActivityTypeSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedActivityType: ActivityType
    
    
    var body: some View {
        HStack {
            Picker("Select activity", selection: $selectedActivityType) {
                ForEach(ActivityType.allCases) { activity in
                    Text("\(activity.rawValue.capitalized)")
                }
            }
            .pickerStyle(.wheel)
            .frame(width: 200, height: 150)
       
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
        .buttonStyle(PlainButtonStyle())
        }
    }


#Preview {
    @Previewable @State var activity: ActivityType = .cycling
    ActivityTypeSettingsView(selectedActivityType: $activity)
}
