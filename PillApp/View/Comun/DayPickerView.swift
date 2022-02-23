//
//  DayPickerView.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 25/1/22.
//

import SwiftUI

struct DayPickerView: View {
    @ObservedObject var dayPickerVM: DayPickerVM
    @Binding var currentDate: Date
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(dayPickerVM.dates, id:\.self) { day in
                    VStack(spacing: 10) {
                        Text(day.extractDate(format: "dd"))
                        Text(day.extractDate(format: "EEE"))
                    }
                    .foregroundColor($currentDate.wrappedValue.currentDate(date: day) ? .white : .red)
                    .frame(width: 45, height: 90)
                    .background {
                        Capsule()
                            .fill(.black)
                    }
                    .onTapGesture {
                        withAnimation {
                            currentDate = day
                            print("Current Date: ", currentDate)
                        }
                    }
                }
            }
            .padding()
        }
        
    }
}

struct DayPickerView_Previews: PreviewProvider {
    static var previews: some View {
        DayPickerView(dayPickerVM: DayPickerVM(), currentDate: .constant(Date()))
    }
}
