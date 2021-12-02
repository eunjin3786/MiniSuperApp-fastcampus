//
//  AppRootComponent.swift
//  MiniSuperApp
//
//  Created by Jinny on 11/22/21.
//

import Foundation
import AppHome
import ProfileHome
import FinanceHome
import FinanceRepository
import ModernRIBs
import TransportHome
import TransportHomeImp
import Topup
import TopupImp
import AddPaymentMethod
import AddPaymentMethodImp
import Network
import NetworkImp
import CombineSchedulers

final class AppRootComponent: Component<AppRootDependency>, AppHomeDependency, FinanceHomeDependency, ProfileHomeDependency, TransportHomeDependency, TopupDependency, AddPaymentMethodDependency {
    
    var mainQueue: AnySchedulerOf<DispatchQueue> { .main }
    
    lazy var transportHomeBuildable: TransportHomeBuildable = {
        return TransportHomeBuilder(dependency: self)
    }()
    
    lazy var topupBuildable: TopupBuildable = {
        return TopupBuilder(dependency: self)
    }()
    
    var topupBaseViewController: ViewControllable {
        return rootViewController.topViewControllable
    }
    
    lazy var addPaymentMethodBuilable: AddPaymentMethodBuildable = {
        return AddPaymentMethodBuilder(dependency: self)
    }()
    
    let cardOnFileRepository: CardOnFileRepository
    let superPayRepository: SuperPayRepository
    
    private let rootViewController: ViewControllable
    
    init(depencency: AppRootDependency,
         rootViewController: ViewControllable) {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [SuperAppURLProtocol.self]
        
        setupURLProtocol()
        
        let network = NetworkImp(session: URLSession(configuration: config))
        
        self.cardOnFileRepository = CardOnFileRepositoryImp(network: network, baseURL: BaseURL().financeBaseURL)
        self.cardOnFileRepository.fetch()
        
        self.superPayRepository = SuperPayRepositoryImp(network: network, baseURL: BaseURL().financeBaseURL)
        self.rootViewController = rootViewController
        super.init(dependency: depencency)
    }
}
