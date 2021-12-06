//
//  File.swift
//  
//
//  Created by Jinny on 12/6/21.
//

import XCTest
import Foundation
import SnapshotTesting
import FinanceEntity
@testable import TopupImp

final class CardOnFileViewTests: XCTestCase {
    
    func testCardOnFile() {
        // given
        let viewModels = [
            PaymentMethodViewModel(PaymentMethod(id: "0", name: "우리은행", digits: "**** 11", color: "#347876ff", isPrimary: false)),
            PaymentMethodViewModel(PaymentMethod(id: "0", name: "우리은행", digits: "**** 11", color: "#347876ff", isPrimary: false)),
            PaymentMethodViewModel(PaymentMethod(id: "0", name: "우리은행", digits: "**** 11", color: "#347876ff", isPrimary: false))
        ]

        // when
        let sut = CardOnFileViewController()
        sut.update(with: viewModels)
        
        // then
        assertSnapshot(matching: sut, as: .image(on: .iPhoneXsMax))
    }
}
