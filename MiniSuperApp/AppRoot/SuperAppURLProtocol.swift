//
//  SuperAppURLProtocol.swift
//  MiniSuperApp
//
//  Created by Jinny on 11/22/21.
//

import Foundation

typealias Path = String
typealias MockResponse = (statusCode: Int, data: Data?)

final class SuperAppURLProtocol: URLProtocol {
    
    static var successMock: [Path: MockResponse] = [:]
    static var failureErrors: [Path: Error] = [:]
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let path = request.url?.path {
            if let mockResposne = SuperAppURLProtocol.successMock[path] {
                
                let resposne = HTTPURLResponse(
                    url: request.url!,
                    statusCode: mockResposne.statusCode,
                    httpVersion: nil,
                    headerFields: nil
                )!
                
                client?.urlProtocol(
                    self,
                    didReceive: resposne,
                    cacheStoragePolicy: .notAllowed
                )
                
                mockResposne.data.map { client?.urlProtocol(self, didLoad: $0) }
            } else if let error = SuperAppURLProtocol.failureErrors[path] {
                client?.urlProtocol(self, didFailWithError: error)
            } else {
                client?.urlProtocol(self, didFailWithError: MockSessionError.notSupported)
            }
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
}

enum MockSessionError: Error {
    case notSupported
}
