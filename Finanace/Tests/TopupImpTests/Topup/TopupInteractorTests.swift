//
//  TopupInteractorTests.swift
//  MiniSuperApp
//
//  Created by Jinny on 12/2/21.
//

@testable import TopupImp
import TopupTestSupport
import XCTest

final class TopupInteractorTests: XCTestCase {

    private var sut: TopupInteractor!
    private var dependency: TopupDependencyMock!
    private var listener: TopupListenerMock!
    private var router: TopupRoutingMock!
    
    override func setUp() {
        super.setUp()
        dependency = TopupDependencyMock()
        listener = TopupListenerMock()
        
        let interactor = TopupInteractor(dependency: dependency)
        router = TopupRoutingMock(interactable: interactor)
        
        interactor.listener = self.listener
        interactor.router = self.router
        self.sut = interactor
    }

    // MARK: - Tests

    func testActivate() {
        
    }
}
