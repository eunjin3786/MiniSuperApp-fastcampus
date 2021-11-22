//
//  File.swift
//  
//
//  Created by Jinny on 11/22/21.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
