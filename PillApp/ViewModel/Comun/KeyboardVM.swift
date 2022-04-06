//
//  KeyboardVM.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 6/4/22.
//

import SwiftUI

final class KeyboardVM: ObservableObject {
    var fields: [Int]
    
    init(fields: [Int]) {
        self.fields = fields
    }
    
    func next(_ actualField: Int?) -> Int? {
        if let actual = actualField {
            if let index = fields.firstIndex(of: actual + 1) {
                print("index: \(fields[index])")
                return fields[index]
            } else {
                return nil
            }
        } else {
            return 0
        }
    }
    
    func previous(_ actualField: Int?) -> Int? {
        if let actual = actualField {
            if let index = fields.firstIndex(of: actual - 1) {
                return fields[index]
            } else {
                return nil
            }
        } else {
            return 0
        }
    }
}
