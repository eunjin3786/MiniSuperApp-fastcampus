//
//  BaseURL.swift
//  MiniSuperApp
//
//  Created by Jinny on 11/22/21.
//

import Foundation

struct BaseURL {
    var financeBaseURL: URL {
        #if UITESTING
        return URL(string: "https://localhost:8080")!
        #else
        return URL(string: "https://finance.superapp.com/api/v1")!
        #endif
    }
}
