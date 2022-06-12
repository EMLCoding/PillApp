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
    
    @State var userParameters: [Parameter] = []
    
    @State var pruebadataPoints: [Double] = [15, 2, 7, 16, 32, 39, 5, 3, 25, 21]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Background").edgesIgnoringSafeArea(.all)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
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
                        .frame(maxWidth: .infinity)
                        Text(analyticsVM.parameterChoosed?.descriptionEn ?? "")
                        
                        if (analyticsVM.parameterChoosed != nil && userParameters.count > 1) {
                            LineGraph(data: analyticsVM.getValuesOf(parameters: userParameters), parameters: userParameters.reversed(), parameterType: analyticsVM.parameterChoosed!)
                                .frame(height: 250)
                                .padding(.top, 25)
                                .padding(.bottom, 25)
                        }
                        
                        
                        if analyticsVM.parameterChoosed != nil {
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
                            
                            Text("* The maximum and minimum values ​​indicated for each parameter are estimates. For more information consult your doctor.")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding()
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
                                DetailUserParameter(detailParametersVM: DetailParametersVM(parameter: nil, parameterTypes: analyticsVM.parameterTypes, userParameters: userParameters))
                            }
                        })
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .loadUserParameters)) { notification in
            userParameters = analyticsVM.loadParameters(context: viewContext)
        }
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView()
    }
}
