//
//  DetailCitasMedicasView.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 13/4/22.
//

import SwiftUI

struct DetailCitasMedicasView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var detailCitasMedicasVM: DetailCitasMedicasVM
    
    @State var isShowingSheetStreets = false
    @State var isShowingSheetMap = false
    
    @FocusState var actualField: MAppoitmentField?
    
    init(detailCitasMedicasVM: DetailCitasMedicasVM) {
        self.detailCitasMedicasVM = detailCitasMedicasVM
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        Form {
            Section(header: Text("Medical consultation")) {
                Menu {
                    Picker(selection: $detailCitasMedicasVM.appoitmentName) {
                        ForEach(DoctorTypes.allCases) { type in
                            Text("\(type.localizedString())")
                        }
                    } label: {
                        Text("")
                    }
                } label: {
                    Text("Name")
                    
                    Spacer()
                    
                    Text("\(detailCitasMedicasVM.appoitmentName.localizedString())")
                }
                
                ZStack(alignment: .topLeading) {
                    if (detailCitasMedicasVM.appoitmentNotes.isEmpty) {
                        Text("Add your notes")
                            .foregroundColor(.gray.opacity(0.5))
                            .padding(.top, 6)
                            .padding(.leading, 5)
                    }
                    
                    TextEditor(text: $detailCitasMedicasVM.appoitmentNotes)
                        .frame(minHeight: 100)
                        .focused($actualField, equals: .notes)
                        .submitLabel(.done)
                }
            }
            
            Section {
                DatePicker("Appointment date", selection: $detailCitasMedicasVM.date)
                    .datePickerStyle(.graphical)
                DatePicker("Reminder", selection: $detailCitasMedicasVM.dateReminder, in: ...detailCitasMedicasVM.date)
            } header: {
                Text("Dates")
            }
            
            Section {
                Button("Search localization", action: {isShowingSheetStreets.toggle()})
                    .sheet(isPresented: $isShowingSheetStreets, content: {
                        NavigationView {
                            StreetsFinder(streetsFinderVM: StreetsFinderVM(), location: $detailCitasMedicasVM.appoitmentLocation)
                        }
                    })
                if (!detailCitasMedicasVM.appoitmentLocation.isEmpty) {
                    Text(detailCitasMedicasVM.appoitmentLocation)
                    Button("See on the map", action: {isShowingSheetMap.toggle()})
                        .sheet(isPresented: $isShowingSheetMap, content: {
                            NavigationView {
                                MapView(mapVM: MapVM(localization: detailCitasMedicasVM.appoitmentLocation))
                            }
                        })
                }
            } header: {
                Text("Location")
            }
        }
        .background(Color("Background"))
        .navigationTitle(detailCitasMedicasVM.isEdition ? "Edit reminder" : "Add reminders")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(detailCitasMedicasVM.isEdition ? "Edit" : "Create") {
                    detailCitasMedicasVM.save(context: viewContext)
                    dismiss()
                }
            }
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Spacer()
                    Button {
                        actualField = nil
                    } label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                }
            }
        }
    }
}

struct DetailCitasMedicasView_Previews: PreviewProvider {
    static var previews: some View {
        DetailCitasMedicasView(detailCitasMedicasVM: DetailCitasMedicasVM(medicalAppoitment: nil))
    }
}
