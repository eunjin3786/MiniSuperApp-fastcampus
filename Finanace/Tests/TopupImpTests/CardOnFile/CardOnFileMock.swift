//
//  File.swift
//  
//
//  Created by Jinny on 12/2/21.
//

import Foundation
import RIBsTestSupport
import FinanceEntity
@testable import TopupImp

final class CardOnFileBuildableMock: CardOnFileBuildable {
    
    var buildHandler: ((_ listener: CardOnFileListener) -> CardOnFileRouting)?
    
    var buildCallCount = 0
    var buildPaymentMethoid: [PaymentMethod]?
    
    func build(withListener listener: CardOnFileListener, paymentMethods: [PaymentMethod]) -> CardOnFileRouting {
        buildCallCount += 1
        buildPaymentMethoid = paymentMethods
        
        if let buildHandler = buildHandler {
            return buildHandler(listener)
        }
        
        fatalError()
    }
}

final class CardOnFileRoutingMock: ViewableRoutingMock, CardOnFileRouting {
    
}
