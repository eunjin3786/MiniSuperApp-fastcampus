//
//  NumberFormatter.swift
//  MiniSuperApp
//
//  Created by Jinny on 11/22/21.
//

import Foundation

struct Formatter {
    static let balanceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}
