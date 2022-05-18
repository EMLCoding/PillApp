//
//  DetailMedicinasView.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 19/3/22.
//

import SwiftUI

struct DetailMedicinasView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var detailMedicinasVM: DetailMedicinasVM
    
    @FocusState var actualField: MedicamentsField?
    
    
    init(detailMedicinasVM: DetailMedicinasVM){
        self.detailMedicinasVM = detailMedicinasVM
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        Form {
            Section(header: Text("Details")) {
                TextField("Name of medicine", text: $detailMedicinasVM.medicineName)
                    .focused($actualField, equals: .name)
                    .submitLabel(.next)
                Menu {
                    Picker(selection: $detailMedicinasVM.category, label: Text("Category")) {
                        ForEach(Categories.allCases) { category in
                            Text("\(category.localizedString())")
                        }
                    }
                } label: {
                    HStack {
                        Text("Category")
                        
                        Spacer()
                        
                        Text("\(detailMedicinasVM.category.localizedString())")
                    }
                }
                
                Menu {
                    Picker(selection: $detailMedicinasVM.icon, label: Text("Icons")) {
                        ForEach(Icons.allCases) { icon in
                            HStack {
                                Image("\(icon)")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 5, height: 5)
                                Text(icon.localizedString())
                            }
                        }
                    }
                } label: {
                    HStack {
                        Text("Icon")
                        
                        Spacer()
                        
                        Text("\(detailMedicinasVM.icon.localizedString())")
                    }
                }
                
                ZStack(alignment: .topLeading) {
                    if (detailMedicinasVM.medicineNotes.isEmpty) {
                        Text("Add your notes")
                            .foregroundColor(.gray.opacity(0.5))
                            .padding(.top, 6)
                            .padding(.leading, 5)
                    }
                    
                    TextEditor(text: $detailMedicinasVM.medicineNotes)
                        .frame(minHeight: 100)
                        .focused($actualField, equals: .notes)
                        .submitLabel(.done)
                }
            }
            
            if !detailMedicinasVM.isEdition {
                Section(header: Text("Dates")) {
                    DatePicker("Initial", selection: $detailMedicinasVM.initialDate,displayedComponents: .date)
                    DatePicker("End", selection: $detailMedicinasVM.finalDate, in: detailMedicinasVM.initialDate...,displayedComponents: .date)
                }
                
                Section(header: Text("Notifications")) {
                    Menu {
                        Picker(selection: $detailMedicinasVM.periodicity, label: Text("Periodicity")) {
                            ForEach(Periodicities.allCases) { periodicity in
                                Text("\(periodicity.localizedString())")
                            }
                        }
                    } label: {
                        HStack {
                            Text("Periodicity")
                            
                            Spacer()
                            
                            Text("\(detailMedicinasVM.periodicity.localizedString())")
                        }
                    }
                    
                    if detailMedicinasVM.periodicity == .day {
                        HStack {
                            Text("Times a day")
                            Picker("", selection: $detailMedicinasVM.dailyPeriodicity) {
                                ForEach(0..<4) {
                                    Text("\(self.detailMedicinasVM.dailyPeriodicities[$0])")
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        DatePicker("First dose", selection: $detailMedicinasVM.hourFirstTime, displayedComponents: .hourAndMinute)
                        
                        if detailMedicinasVM.dailyPeriodicity == 1 {
                            DatePicker("Second dose", selection: $detailMedicinasVM.hourSecondTime, in: detailMedicinasVM.hourFirstTime...,displayedComponents: .hourAndMinute)
                        } else if detailMedicinasVM.dailyPeriodicity == 2 {
                            DatePicker("Second dose", selection: $detailMedicinasVM.hourSecondTime, in: detailMedicinasVM.hourFirstTime...,displayedComponents: .hourAndMinute)
                            DatePicker("Third dose", selection: $detailMedicinasVM.hourThirdTime, in: detailMedicinasVM.hourSecondTime...,displayedComponents: .hourAndMinute)
                        } else if detailMedicinasVM.dailyPeriodicity == 3 {
                            DatePicker("Second dose", selection: $detailMedicinasVM.hourSecondTime, in: detailMedicinasVM.hourFirstTime...,displayedComponents: .hourAndMinute)
                            DatePicker("Third dose", selection: $detailMedicinasVM.hourThirdTime, in: detailMedicinasVM.hourSecondTime...,displayedComponents: .hourAndMinute)
                            DatePicker("Fourth dose", selection: $detailMedicinasVM.hourFourthTime, in: detailMedicinasVM.hourThirdTime...,displayedComponents: .hourAndMinute)
                        }
                    } else if detailMedicinasVM.periodicity == .week {
                        Menu {
                            Picker(selection: $detailMedicinasVM.dayOfWeek, label: Text("Day of the week")) {
                                ForEach(DaysOfWeek.allCases) { day in
                                    Text(day.localizedString())
                                }
                            }
                        } label: {
                            HStack {
                                Text("Day of the week")
                                
                                Spacer()
                                
                                Text("\(detailMedicinasVM.dayOfWeek.localizedString())")
                            }
                        }
                        DatePicker("Time of first dose", selection: $detailMedicinasVM.hourFirstTime, displayedComponents: .hourAndMinute)
                    } else {
                        DatePicker("Time of first dose", selection: $detailMedicinasVM.hourFirstTime, displayedComponents: .hourAndMinute)
                    }
                }
            }
            
            if detailMedicinasVM.isEdition {
                Section("Medicine time") {
                    DatePicker("Date", selection: $detailMedicinasVM.medicineDate)
                        .datePickerStyle(.graphical)
                }
            }
        }
        .background(Color("Background"))
        .navigationTitle(detailMedicinasVM.isEdition ? "Edit reminder" : "Add reminders")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(detailMedicinasVM.isEdition ? "Edit" : "Create") {
                    detailMedicinasVM.save(context: viewContext)
                    dismiss()
                }
                .disabled(detailMedicinasVM.medicineName == "")
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

struct DetailMedicinasView_Previews: PreviewProvider {
    static var previews: some View {
        DetailMedicinasView(detailMedicinasVM: DetailMedicinasVM(medicine: nil))
    }
}
