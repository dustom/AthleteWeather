import SwiftUI

struct WeatherSettingsView: View {
    @ObservedObject var viewModel: CurrentWeatherViewModel
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Displayed Information")) {
                    ForEach(viewModel.propertiesArray) { property in
                        HStack {
                            Text(property.name)
                            Spacer()
                            Button {
                                withAnimation {
                                    toggleProperty(property)
                                }
                            } label: {
                                Image(systemName: property.info.isIncluded ? "checkmark.square" : "square")
                                    .symbolRenderingMode(.hierarchical)
                                    
                            }
                        }
                        .foregroundColor(property.info.isIncluded ? .primary : .secondary)
                    }
                    .onMove(perform: move)
                }
            }
            .toolbar {
                EditButton()
                    .foregroundStyle(.primary)
            }
            .navigationTitle("Weather Settings")
        }
    }
    
    // this function allows user to change a position of a property which is then reflected in the main view
    private func move(from source: IndexSet, to destination: Int) {
        viewModel.propertiesArray.move(fromOffsets: source, toOffset: destination)
    }
    
    // this function allows user to choose if they want to see a specific weather property on the Current Weather tab
    private func toggleProperty(_ property: WeatherProperty) {
        if let index = viewModel.propertiesArray.firstIndex(where: { $0.name == property.name }) {
            viewModel.propertiesArray[index].info.isIncluded.toggle()
        }
    }
}

#Preview {
    let viewModel = CurrentWeatherViewModel()
    return WeatherSettingsView(viewModel: viewModel)
}
