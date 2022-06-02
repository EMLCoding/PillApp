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
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Background").edgesIgnoringSafeArea(.all)
                ScrollView(.vertical, showsIndicators: false) {
                    HStack {
                        Text("Choose parameter")
                        
                        Menu(analyticsVM.parameterChoosed?.name ?? "Parameter") {
                            ForEach(analyticsVM.parameterTypes) { type in
                                Button {
                                    analyticsVM.parameterChoosed = type
                                    NotificationCenter.default.post(name: .loadUserParameters, object: nil)
                                } label: {
                                    Text(type.name)
                                }

                            }
                        }
                    }
                    Text(analyticsVM.parameterChoosed?.descriptionEn ?? "")
                    Text("TODO: Añadir la gráfica")
                    
                    Button("See all registers", action: {isShowingSheetList.toggle()})
                        .sheet(isPresented: $isShowingSheetList, content: {
                            NavigationView {
                                ListUserParameters(analyticsVM: analyticsVM, userParameters: analyticsVM.userParameters, nameParameter: analyticsVM.parameterChoosed?.name ?? "")
                            }
                        })
                        .disabled(analyticsVM.parameterChoosed == nil)

                    Text("The values state for each parameter are estimates. For more information consult your doctor")
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
