//
//  DayPickerView.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 25/1/22.
//

import SwiftUI

struct DayPickerView: View {
    @ObservedObject var dayPickerVM: DayPickerVM
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(dayPickerVM.dates, id:\.self) { day in
                    Text("\(day)")
                }
            }
        }
    }
}

struct DayPickerView_Previews: PreviewProvider {
    static var previews: some View {
        DayPickerView(dayPickerVM: DayPickerVM())
    }
}
