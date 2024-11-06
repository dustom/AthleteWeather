//
//  RecommendationsView.swift
//  AthleteWeather
//
//  Created by Tomáš Dušek on 30.10.2024.
//

import SwiftUI

struct RecommendationsView: View {
    @State private var selectedHours: Int = 1
    @State private var selectedMinutes: Int = 3
    @State private var selectedActivityType: ActivityType = .cycling
    @State private var showDurationSettings = false
    @State private var isDurationPressed = false
    @State private var isActivityTypePressed = false
    @State private var showActivityTypeSettings = false
    @ObservedObject private var vm = RecommendationsViewModel()
    @EnvironmentObject var weatherForSelection: WeatherForSelection
    
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ScrollView(showsIndicators: false) {
                    VStack {
                        // MARK: ScrollWheel to select duration
                        VStack {
                            VStack {
                                Spacer()
                                HStack{
                                    HStack{
                                        Button {
                                            isDurationPressed = true
                                            showDurationSettings = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                                isDurationPressed = false
                                            }
                                        } label: {
                                            
                                            HStack {
                                                Text("Duration")
                                                    .font(.subheadline)
                                                Spacer()
                                                
                                                
                                                Text("\(selectedHours)hr \(selectedMinutes * 10)min")
                                                    .font(.title2)
                                                    
                                                Image(systemName: "chevron.right")
                                                    .padding(.leading, 20)
                                                
                                            }
                                            
                                            
                                        }
                                        .sheet(isPresented: $showDurationSettings, onDismiss: updateRecommendations){
                                            ActivityDurationSettingsView(selectedHours: $selectedHours, selectedMinutes: $selectedMinutes)
                                                .presentationDetents([.fraction(0.3)])
                                        }
                                    }
                                    .padding()
                                    .frame(width: geo.size.width/1.1, height: 60)
                                    .background(.ultraThickMaterial.opacity(0.8))
                                    .clipShape(.rect(cornerRadius: 15))
                                    .scaleEffect(isDurationPressed ? 0.95 : 1.0)
                                    .animation(.spring(response: 0.2, dampingFraction: 0.5), value: isDurationPressed)
                                    .tint(.primary)
                                    
                                }
                                HStack{
                                    HStack{
                                        Button {
                                            isActivityTypePressed = true
                                            showActivityTypeSettings = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                                isActivityTypePressed = false
                                            }
                                        } label: {
                                            
                                            HStack {
                                                Text("Type")
                                                    .font(.subheadline)
                                                Spacer()
                                                Text("\(selectedActivityType.rawValue.capitalized)")
                                                    .font(.title2)
                                                
                                                Image(systemName: "chevron.right")
                                                    .padding(.leading, 20)
                                                
                                            }
                                            
                                            
                                        }
                                        .sheet(isPresented: $showActivityTypeSettings, onDismiss: updateRecommendations){
                                            ActivityTypeSettingsView(selectedActivityType: $selectedActivityType)
                                                .presentationDetents([.fraction(0.3)])
                                        }
                                    }
                                    .padding()
                                    .frame(width: geo.size.width/1.1, height: 60)
                                    .background(.ultraThickMaterial.opacity(0.8))
                                    .clipShape(.rect(cornerRadius: 15))
                                    .scaleEffect(isActivityTypePressed ? 0.95 : 1.0)
                                    .animation(.spring(response: 0.2, dampingFraction: 0.5), value: isActivityTypePressed)
                                    .tint(.primary)
                                    
                                }
                            }
                        }
                        .frame(width: geo.size.width)
                        
                        
                        // MARK: Nutrition
                        Divider()
                        VStack {
                            
                            HStack{
                                Text("Recommended Nutriotion:")
                                    .font(.title3)
                                    .padding(.leading)
                                Spacer()
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false){
                                HStack{
                                    ForEach(vm.nutrition) {item in
                                        HStack{
                                            NutritionItemView(nutritionItem: item)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // MARK: Clothing
                        Divider()
                        VStack {
                            HStack{
                                Text("Recommended Clothing:")
                                    .font(.title3)
                                    .padding(.leading)
                                Spacer()
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false){
                                HStack{
                                    ForEach(vm.clothing) { item in
                                        HStack{
                                            ClothingItemView(clothingItem: item)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .navigationTitle("Recommendations")
                        .toolbarBackground(.ultraThinMaterial)
                        Spacer()
                    }
                }
            }
            .background(.blue.mix(with: .gray, by: weatherForSelection.cloudiness ?? 0).opacity(0.4))
        }
        .onAppear() {
            updateRecommendations()
        }
        //                .preferredColorScheme(.dark)
    }
    
    private func updateRecommendations() {
        let activityDuration = Double(selectedHours) + Double(selectedMinutes)/6
        vm.recommendClothing(for: weatherForSelection, type: selectedActivityType)
        vm.recommendNutrition(for: activityDuration)
        showDurationSettings = false
    }
    
}

#Preview {
    RecommendationsView()
        .environmentObject(WeatherForSelection())
}
