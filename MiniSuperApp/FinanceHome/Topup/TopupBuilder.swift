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
    var superPayRepository: SuperPayRepository { get }
}

final class TopupComponent: Component<TopupDependency>, TopupInteractorDependency, AddPaymentMethodDependency, EnterAmountDependency, CardOnFileDependency {
    
    var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { paymentMethodStream }
    
    var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
    fileprivate var topupBaseViewController: ViewControllable {
        return dependency.topupBaseViewController
    }
    
    var superPayRepository: SuperPayRepository { dependency.superPayRepository }
    let paymentMethodStream: CurrentValuePublisher<PaymentMethod>
    
    init(dependency: TopupDependency,
         paymentMethodStream: CurrentValuePublisher<PaymentMethod>) {
        self.paymentMethodStream = paymentMethodStream
        super.init(dependency: dependency)
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
        let paymentMethodStream = CurrentValuePublisher(PaymentMethod(id: "", name: "", digits: "", color: "", isPrimary: false))
        let component = TopupComponent(dependency: dependency, paymentMethodStream: paymentMethodStream)
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
