//
//  TopupRouter.swift
//  MiniSuperApp
//
//  Created by Jinny on 11/8/21.
//

import ModernRIBs

protocol TopupInteractable: Interactable, AddPaymentMethodListener, EnterAmountListener, CardOnFileListener {
    var router: TopupRouting? { get set }
    var listener: TopupListener? { get set }
    
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

final class TopupRouter: Router<TopupInteractable>, TopupRouting {

    private var navigationControllable: NavigationControllerable?
    
    private let addPaymentMethodBuilder: AddPaymentMethodBuildable
    private var addPaymentMethodRouting: Routing?
    
    private let enterAmountBuilder: EnterAmountBuildable
    private var enterAmountRouting: Routing?
    
    private let cardOnFileBuilder: CardOnFileBuildable
    private var cardOnFileRouting: Routing?
    
    init(interactor: TopupInteractable,
         viewController: ViewControllable,
         addPaymentMethodBuilder: AddPaymentMethodBuildable,
         enterAmountBuilder: EnterAmountBuildable,
         cardOnFileBuilder: CardOnFileBuildable) {
        self.viewController = viewController
        self.addPaymentMethodBuilder = addPaymentMethodBuilder
        self.enterAmountBuilder = enterAmountBuilder
        self.cardOnFileBuilder = cardOnFileBuilder
        super.init(interactor: interactor)
        interactor.router = self
    }
    
    func cleanupViews() {
        if viewController.uiviewController.presentingViewController != nil, navigationControllable != nil {
            navigationControllable?.dismiss(completion: nil)
        }
    }
    
    func attachAddPaymentMethod() {
        if addPaymentMethodRouting != nil {
            return
        }
        
        let router = addPaymentMethodBuilder.build(withListener: interactor)
        presentInsideNavigation(router.viewControllable)
        attachChild(router)
        addPaymentMethodRouting = router
    }
    
    func detachAddPaymentMethod() {
        guard let router = addPaymentMethodRouting else {
            return
        }
        
        dismissPresentationNavigation(completion: nil)
        detachChild(router)
        addPaymentMethodRouting = nil
    }
    
    func attachEnterAmount() {
        if enterAmountRouting != nil {
            return
        }
        
        let router = enterAmountBuilder.build(withListener: interactor)
        presentInsideNavigation(router.viewControllable)
        attachChild(router)
        enterAmountRouting = router
    }
    
    func detachEnterAmount() {
        guard let router = enterAmountRouting else {
            return
        }
        
        dismissPresentationNavigation(completion: nil)
        detachChild(router)
        enterAmountRouting = nil
    }
    
    func attachCardOnFile() {
        if cardOnFileRouting != nil {
            return
        }
        
        let router = cardOnFileBuilder.build(withListener: interactor)
        navigationControllable?.pushViewController(router.viewControllable, animated: true)
        cardOnFileRouting = router
        attachChild(router)
    }
    
    func detachCardOnFile() {
        guard let router = cardOnFileRouting else {
            return
        }
        
        navigationControllable?.popViewController(animated: true)
        detachChild(router)
        cardOnFileRouting = nil
    }
    
    private func presentInsideNavigation(_ viewControllable: ViewControllable) {
        let navigation = NavigationControllerable(root: viewControllable)
        navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
        self.navigationControllable = navigation
        viewController.present(navigation, animated: true, completion: nil)
    }
    
    private func dismissPresentationNavigation(completion: (() -> Void)?) {
        if self.navigationControllable == nil {
            return
        }
        
        viewController.dismiss(completion: nil)
        self.navigationControllable = nil
    }

    // MARK: - Private
    private let viewController: ViewControllable
}
