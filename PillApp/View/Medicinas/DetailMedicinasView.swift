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
    
    @State var alertPresented = false
    var body: some View {
        Form {
            Section(header: Text("Details")) {
                TextField("Name of medicine", text: $detailMedicinasVM.medicineName)
                
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
                                Text(icon.rawValue)
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
                                            ForEach(0 ..< $detailMedicinasVM.dailyPeriodicities.count) {
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
                                    Picker(selection: $detailMedicinasVM.dayOfWeek, label: Text("Day of the week")) {
                                        ForEach(DaysOfWeek.allCases) { day in
                                            Text(day.localizedString())
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
        .navigationTitle("Add reminders")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(detailMedicinasVM.isEdition ? "Edit" : "Create") {
                    detailMedicinasVM.save(context: viewContext)
                    dismiss()
                }
                .disabled(detailMedicinasVM.medicineName == "")
            }
        }
    }
}

struct DetailMedicinasView_Previews: PreviewProvider {
    static var previews: some View {
        DetailMedicinasView(detailMedicinasVM: DetailMedicinasVM(medicine: nil))
    }
}
