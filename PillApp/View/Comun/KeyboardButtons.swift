//
//  KeyboardButtons.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 6/4/22.
//

import SwiftUI

struct KeyboardButtons: View {
    @StateObject var keyboardVM: KeyboardVM
    var actualField: FocusState<Int?>.Binding
    
    var fields: [Int] = [0,1]
    
    var body: some View {
        HStack {
            Button {
                actualField.wrappedValue = keyboardVM.previous(actualField.wrappedValue)
            } label: {
                Image(systemName: "chevron.up")
            }
            Button {
                actualField.wrappedValue = keyboardVM.next(actualField.wrappedValue)
            } label: {
                Image(systemName: "chevron.down")
            }
            Spacer()
            Button {
                actualField.wrappedValue = nil
            } label: {
                Image(systemName: "keyboard")
            }

        }
    }
}
