//
//  AnalyticsView.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 1/6/22.
//

import SwiftUI

struct AnalyticsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var analyticsVM: AnalyticsVM
    @State var isShowingSheetDetails = false
    @State var isShowingSheetList = false
    
    @State var pruebadataPoints: [Double] = [15, 2, 7, 16, 32, 39, 5, 3, 25, 21]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Background").edgesIgnoringSafeArea(.all)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        HStack {
                            Text("Choose parameter:")
                            
                            Menu(analyticsVM.parameterChoosed?.name ?? (NSLocale.preferredLanguages[0] == "es" ? "Parámetro" : "Parameter")) {
                                ForEach(analyticsVM.parameterTypes) { type in
                                    Button {
                                        analyticsVM.parameterChoosed = type
                                        analyticsVM.loadParameters(context: viewContext)
                                        NotificationCenter.default.post(name: .loadUserParameters, object: nil)
                                    } label: {
                                        Text(type.name)
                                    }
                                    
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        Text((NSLocale.preferredLanguages[0] == "es" ? analyticsVM.parameterChoosed?.descriptionEs : analyticsVM.parameterChoosed?.descriptionEn) ?? "")
                        
                        if (analyticsVM.parameterChoosed != nil && analyticsVM.userParameters.count <= 1) {
                            Text("* Add two or more records to see the progress in a graph.")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                                .padding(.top)
                        }
                        
                        if (analyticsVM.parameterChoosed != nil && analyticsVM.userParameters.count > 1) {
                            LineGraph(data: analyticsVM.getValuesOf(parameters: analyticsVM.userParameters), parameters: analyticsVM.userParameters.reversed(), parameterType: analyticsVM.parameterChoosed!)
                                .frame(height: 250)
                                .padding(.top, 25)
                                .padding(.bottom, 30)
                            
                            Text("* The maximum and minimum values ​​indicated for each parameter are estimates. For more information consult your doctor.")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                                .padding(.bottom)
                        }
                        
                        
                        if analyticsVM.parameterChoosed != nil && analyticsVM.userParameters.count > 0 {
                            Button("See all registers", action: {isShowingSheetList.toggle()})
                                .foregroundColor(.white)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(Color("MainColor"))
                                )
                                .sheet(isPresented: $isShowingSheetList, content: {
                                    NavigationView {
                                        ListUserParameters(analyticsVM: analyticsVM, nameParameter: analyticsVM.parameterChoosed?.name ?? "")
                                    }
                                })
                        }
                    }
                }
            }
            .navigationTitle("Analytics")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add", action: {isShowingSheetDetails.toggle()})
                        .sheet(isPresented: $isShowingSheetDetails, content: {
                            NavigationView {
                                DetailUserParameter(detailParametersVM: DetailParametersVM(parameter: nil, parameterTypes: analyticsVM.parameterTypes, userParameters: analyticsVM.userParameters))
                            }
                        })
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onReceive(NotificationCenter.default.publisher(for: .loadUserParameters)) { notification in
            analyticsVM.loadParameters(context: viewContext)
        }
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView()
    }
}
