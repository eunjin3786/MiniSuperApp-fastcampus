//
//  TopupBuilder.swift
//  MiniSuperApp
//
//  Created by Jinny on 11/8/21.
//

import ModernRIBs

protocol TopupDependency: Dependency {
    var cardOnFileRepository: CardOnFileRepository { get }
    var topupBaseViewController: ViewControllable { get }
}

final class TopupComponent: Component<TopupDependency>, TopupInteractorDependency, AddPaymentMethodDependency, EnterAmountDependency, CardOnFileDependency {
    
    var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
    fileprivate var topupBaseViewController: ViewControllable {
        return dependency.topupBaseViewController
    }
}

// MARK: - Builder

protocol TopupBuildable: Buildable {
    func build(withListener listener: TopupListener) -> TopupRouting
}

final class TopupBuilder: Builder<TopupDependency>, TopupBuildable {

    override init(dependency: TopupDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TopupListener) -> TopupRouting {
        let component = TopupComponent(dependency: dependency)
        let interactor = TopupInteractor(dependency: component)
        interactor.listener = listener
        let addPaymentMethodBuilder = AddPaymentMethodBuilder(dependency: component)
        let enterAmountBuilder = EnterAmountBuilder(dependency: component)
        let cardOnFileBuilder = CardOnFileBuilder(dependency: component)
        return TopupRouter(interactor: interactor,
                           viewController: component.topupBaseViewController,
                           addPaymentMethodBuilder: addPaymentMethodBuilder,
                           enterAmountBuilder: enterAmountBuilder,
                           cardOnFileBuilder: cardOnFileBuilder)
    }
}
