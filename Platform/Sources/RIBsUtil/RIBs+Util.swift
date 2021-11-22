//
//  File.swift
//  
//
//  Created by Jinny on 11/22/21.
//

import Foundation
import RIBsUtil

public enum DismissButtonType {
    case back, close
    
    public var iconSystemName: String {
        switch self {
        case .back:
            return "chevron.backward"
        case .close:
            return "xmark"
        }
    }
}
