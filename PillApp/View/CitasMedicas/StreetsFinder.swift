//
//  StreetsFinder.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 18/4/22.
//

import SwiftUI

struct StreetsFinder: View {
    @Environment(\.presentationMode) private var presentation
    @ObservedObject var streetsFinderVM: StreetsFinderVM
    
    @Binding var location: String
    
    var body: some View {
        ZStack {
            if (streetsFinderVM.localizations.isEmpty) {
                VStack(alignment: .center) {
                    Image(systemName: "magnifyingglass.circle")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color("MainColor"))
                        .frame(width: 80, height: 80)
                    Text("Find the address of your medical center or hospital here.")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
            }
                List {
                    ForEach(streetsFinderVM.localizations, id: \.self) { localization in
                        HStack {
                            Image(systemName: "mappin.circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding(.trailing)
                            VStack(alignment: .leading) {
                                Text(localization.title)
                                    .foregroundColor(Color("MainColor"))
                                
                                if (localization.subtitle != "") {
                                    Text(localization.subtitle)
                                        .foregroundColor(Color("MainColor"))
                                        .opacity(0.7)
                                }
                            }
                        }
                        .onTapGesture {
                            location = localization.title + "," + localization.subtitle
                            self.presentation.wrappedValue.dismiss()
                        }
                    }
                }
        }
        .searchable(text: $streetsFinderVM.direction)
        .navigationTitle("Search localization")
    }
}

struct StreetsFinder_Previews: PreviewProvider {
    static var previews: some View {
        StreetsFinder(streetsFinderVM: StreetsFinderVM(), location: .constant(""))
    }
}
