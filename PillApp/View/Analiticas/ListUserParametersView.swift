//
//  ListMeasurements.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 1/6/22.
//

import SwiftUI

struct ListUserParameters: View {
    @ObservedObject var analyticsVM: AnalyticsVM
    @State var userParameters: [Parameter]
    let nameParameter: String
    
    var body: some View {
        Group {
            if userParameters.isEmpty {
                Group {
                    

                    VStack(alignment: .center) {
                        Image(systemName: "staroflife.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color("MainColor"))
                            .frame(width: 80, height: 80)
                        Text("Add the results of your last analytic.")
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                }
            } else {
                List {
                    ForEach(userParameters) { userParameter in
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
                    .onDelete { index in
                        analyticsVM.deleteUserParameter(indexSet: index)
                    }
                }
            }
        }
        .navigationTitle(nameParameter)
        
    }
}

struct ListMeasurements_Previews: PreviewProvider {
    static var previews: some View {
        ListUserParameters(analyticsVM: AnalyticsVM(), userParameters: [PersistenceController.testParameter], nameParameter: "Parameter")
    }
}
