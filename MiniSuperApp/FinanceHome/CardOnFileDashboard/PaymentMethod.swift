//
//  PaymentMethod.swift
//  MiniSuperApp
//
//  Created by Jinny on 11/1/21.
//

import Foundation

struct PaymentMethod: Decodable {
    let id: String
    let name: String
    let digits: String
    let color: String
    let isPrimary: Bool
}
