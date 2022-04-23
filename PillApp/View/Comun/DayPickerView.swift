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
            ScrollViewReader { value in
                HStack {
                    ForEach(dayPickerVM.dates, id:\.self) { day in
                        VStack(spacing: 5) {
                            Text(day.extractDate(format: "dd"))
                                .font(.title)
                                .bold()
                            Text(day.extractDate(format: "EEE"))
                                .font(.caption)
                        }
                        .foregroundColor(.white)
                        .frame(width: 45, height: 75)
                        .background {
                            Capsule()
                                .fill(
                                    $currentDate.wrappedValue.currentDate(date: day) ? LinearGradient(gradient: Gradient(colors: [ Color("InitialGradient"), Color("MainColor")]), startPoint: .top, endPoint: .bottom) : LinearGradient(gradient: Gradient(colors: [.gray, .black]), startPoint: .top, endPoint: .bottom)
                                )
                        }
                        .onTapGesture {
                            withAnimation {
                                currentDate = day
                            }
                        }
                    }
                }
                .onAppear {
                    if let index = dayPickerVM.dates.firstIndex(where: {Calendar.current.startOfDay(for: $0) == Calendar.current.startOfDay(for: currentDate)}) {
                        value.scrollTo(dayPickerVM.dates[index])
                    }
                }
            }
            
        }
        
    }
}

struct DayPickerView_Previews: PreviewProvider {
    static var previews: some View {
        DayPickerView(dayPickerVM: DayPickerVM(), currentDate: .constant(Date()))
    }
}
