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

final class AppRootComponent: Component<AppRootDependency>, AppHomeDependency, FinanceHomeDependency, ProfileHomeDependency, TransportHomeDependency  {
    
    lazy var transportHomeBuildable: TransportHomeBuildable = {
        return TransportHomeBuilder(dependency: self)
    }()
    
    let cardOnFileRepository: CardOnFileRepository
    let superPayRepository: SuperPayRepository
    
    init(depencency: AppRootDependency,
         cardOnFileRepository: CardOnFileRepository,
         superPayRepository: SuperPayRepository) {
        self.cardOnFileRepository = cardOnFileRepository
        self.superPayRepository = superPayRepository
        super.init(dependency: depencency)
    }
}
