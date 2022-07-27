//
//  AnalyticsView.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 1/6/22.
//

import SwiftUI

struct AnalyticsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    @EnvironmentObject var analyticsVM: AnalyticsVM
    @State var isShowingSheetDetails = false
    @State var isShowingSheetList = false
    
    @State var pruebadataPoints: [Double] = [15, 2, 7, 16, 32, 39, 5, 3, 25, 21]
    
    init() {
            UITableView.appearance().showsVerticalScrollIndicator = false
        }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Background").edgesIgnoringSafeArea(.all)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        HStack {
                            Text("Choose parameter:")
                            
                            Menu((isSpanish() ? analyticsVM.parameterChoosed?.nameEs : analyticsVM.parameterChoosed?.nameEn) ?? (isSpanish() ? "Parámetro" : "Parameter")) {
                                ForEach(analyticsVM.parameterTypes) { type in
                                    Button {
                                        analyticsVM.parameterChoosed = type
                                        analyticsVM.loadParameters(context: viewContext)
                                        NotificationCenter.default.post(name: .loadUserParameters, object: nil)
                                    } label: {
                                        Text((isSpanish() ? type.nameEs : type.nameEn))
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        Text((isSpanish() ? analyticsVM.parameterChoosed?.descriptionEs : analyticsVM.parameterChoosed?.descriptionEn) ?? "")
                            .padding(.horizontal)
                        
                        if (analyticsVM.parameterChoosed != nil && analyticsVM.userParameters.count <= 1) {
                            Text("* Add two or more records to see the progress in a graph.")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                                .padding(.top)
                        }
                        
                        if let parameterType = analyticsVM.parameterChoosed, analyticsVM.userParameters.count > 1 {
                            Group {
                                Text("Valores:")
                                    .foregroundColor(Color("MainColor"))
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top)
                                
                                HStack {
                                    if let minValueM = parameterType.minValueM {
                                        Text("Min man:")
                                            .font(.caption.bold())
                                        Text("\(minValueM, specifier: "%.2f") \(parameterType.unit)")
                                            .font(.caption.bold())
                                        Spacer()
                                    }
                                    
                                    if let maxValueM = parameterType.maxValueM {
                                        Text("Max man:")
                                            .font(.caption.bold())
                                        Text("\(maxValueM, specifier: "%.2f") \(parameterType.unit)")
                                            .font(.caption.bold())
                                    }
                                }
                                .padding(.top, 3)
                                HStack {
                                    if let minValue = parameterType.minValueF {
                                        Text("Min woman:")
                                            .font(.caption.bold())
                                        Text("\(minValue, specifier: "%.2f") \(parameterType.unit)")
                                            .font(.caption.bold())
                                        Spacer()
                                    }
                                    
                                    if let maxValue = parameterType.maxValueF {
                                        Text("Max woman:")
                                            .font(.caption.bold())
                                        Text("\(maxValue, specifier: "%.2f") \(parameterType.unit)")
                                            .font(.caption.bold())
                                    }
                                }
                                .padding(.vertical, 3)
                            }
                            .padding(.horizontal)
                            LineGraph(data: analyticsVM.getValuesOf(parameters: analyticsVM.userParameters), parameters: analyticsVM.userParameters.reversed(), parameterType: parameterType)
                                .frame(height: 250)
                                .padding(.top, 25)
                            
                            Text("* The maximum and minimum values ​​indicated for each parameter are estimates. For more information consult your doctor.")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                                .padding(.bottom)
                        }
                        
                        
                        if analyticsVM.parameterChoosed != nil && analyticsVM.userParameters.count > 0 {
                            
                            List {
                                ForEach(analyticsVM.userParameters) { userParameter in
                                    NavigationLink {
                                        DetailUserParameter(detailParametersVM: DetailParametersVM(parameter: userParameter, parameterTypes: analyticsVM.parameterTypes, userParameters: analyticsVM.userParameters, parameterType: nil))
                                    } label: {
                                        HStack {
                                            Image(systemName: "heart.text.square")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundColor(Color("MainColor"))
                                                .frame(width: 20, height: 20)
                                            Text("\(userParameter.value, specifier: "%.2f")")
                                                .padding(5)
                                            
                                            Spacer()
                                            Text("\((userParameter.date ?? Date.now).extractDate(format: "dd/MM/yyyy"))")
                                                .opacity(0.5)
                                                .padding(5)
                                            
                                        }
                                    }

                                }
                                .onDelete { index in
                                    analyticsVM.deleteUserParameterAt(indexSet: index, userParameters: analyticsVM.userParameters, context: viewContext)
                                }
                            }.frame(height: minRowHeight * CGFloat(analyticsVM.userParameters.count + 1))
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
                                DetailUserParameter(detailParametersVM: DetailParametersVM(parameter: nil, parameterTypes: analyticsVM.parameterTypes, userParameters: analyticsVM.userParameters, parameterType: analyticsVM.parameterChoosed))
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
