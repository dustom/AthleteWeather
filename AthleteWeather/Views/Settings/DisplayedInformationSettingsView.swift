import SwiftUI

struct DisplayedInformationSettingsView: View {
    @ObservedObject var viewModel = CurrentWeatherViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            NavigationView {
                List {
                    Section(header: Text("Displayed Information")) {
                        ForEach(viewModel.propertiesArray) { property in
                            HStack {
                                Toggle(isOn: Binding(
                                    get: { property.info.isIncluded },
                                    set: { newValue in
                                        toggleProperty(property, newValue: newValue)
                                    }
                                )) {
                                    HStack {
                                        Image(systemName: property.icon)
                                            .frame(width: 30)
                                        Text(property.name)
                                    }
                                }
                            }
                            .foregroundColor(property.info.isIncluded ? .primary : .secondary)
                        }
                        .onMove(perform: move)
                    }
                }
//                .toolbar {
//                    EditButton()
//                        .foregroundStyle(.primary)
//                }
                .navigationTitle("Current Weather")
            }
//            Button {
//                dismiss()
//            } label: {
//                Text("Save")
//                    .foregroundColor(.primary)
//                    .padding()
//                    .frame(maxWidth: 150)
//                    .background(Color.primary.opacity(0.1))
//                    .cornerRadius(8)
//            }
//            .buttonStyle(PlainButtonStyle())
        }
    }

    private func move(from source: IndexSet, to destination: Int) {
        viewModel.propertiesArray.move(fromOffsets: source, toOffset: destination)
    }

    private func toggleProperty(_ property: WeatherProperty, newValue: Bool) {
        if let index = viewModel.propertiesArray.firstIndex(where: { $0.name == property.name }) {
            viewModel.propertiesArray[index].info.isIncluded = newValue
        }
    }
}

#Preview {
    let viewModel = CurrentWeatherViewModel()
    return DisplayedInformationSettingsView(viewModel: viewModel)
}
