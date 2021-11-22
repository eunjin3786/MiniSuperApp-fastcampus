import ModernRIBs
import RIBsUtil
import AddPaymentMethod
import SuperUI

protocol FinanceHomeInteractable: Interactable, SuperPayDashboardListener, CardOnFileDashboardListener, AddPaymentMethodListener, TopupListener {
    var router: FinanceHomeRouting? { get set }
    var listener: FinanceHomeListener? { get set }
    
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol FinanceHomeViewControllable: ViewControllable {
    func addDashboard(_ view: ViewControllable)
}

final class FinanceHomeRouter: ViewableRouter<FinanceHomeInteractable, FinanceHomeViewControllable>, FinanceHomeRouting {
    
    private let superPayDashboardBuilder: SuperPayDashboardBuildable
    private var superPayRouting: Routing?
    
    private let cardOnFileDashboardBuilder: CardOnFileDashboardBuildable
    private var cardOnFileDashboardRouting: Routing?
    
    private let addPaymentMethodBuilder: AddPaymentMethodBuildable
    private var addPaymentMethodRouting: Routing?
    
    private let topupBuilder: TopupBuildable
    private var topupRouting: Routing?
    
    init(interactor: FinanceHomeInteractable,
         viewController: FinanceHomeViewControllable,
         superPayDashboardBuilder: SuperPayDashboardBuildable,
         cardOnFileDashboardBuilder: CardOnFileDashboardBuildable,
         addPaymentMethodBuilder: AddPaymentMethodBuildable,
         topupBuilder: TopupBuildable) {
        self.superPayDashboardBuilder = superPayDashboardBuilder
        self.cardOnFileDashboardBuilder = cardOnFileDashboardBuilder
        self.addPaymentMethodBuilder = addPaymentMethodBuilder
        self.topupBuilder = topupBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachSuperPayDashboard() {
        if superPayRouting != nil {
            return
        }
        
        let router = superPayDashboardBuilder.build(withListener: interactor)
        
        let dashboard = router.viewControllable
        viewController.addDashboard(dashboard)
        
        superPayRouting = router
        attachChild(router)
    }
    
    func attachCardOnFileDashboard() {
        if cardOnFileDashboardRouting != nil {
            return
        }
        
        let router = cardOnFileDashboardBuilder.build(withListener: interactor)
        
        let dashboard = router.viewControllable
        viewController.addDashboard(dashboard)
        
        cardOnFileDashboardRouting = router
        attachChild(router)
    }
    
    func attachAddPaymentMethod(closeButtonType: DismissButtonType) {
        if addPaymentMethodRouting != nil {
            return
        }
        
        let router = addPaymentMethodBuilder.build(withListener: self.interactor, closeButtonType: closeButtonType)
        let navigation = NavigationControllerable(root: router.viewControllable)
        navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
        viewControllable.present(navigation, animated: true, completion: nil)
        
        addPaymentMethodRouting = router
        attachChild(router)
    }
    
    func detachAddPaymentMethod() {
        guard let router = addPaymentMethodRouting else {
            return
        }
        
        viewControllable.dismiss(completion: nil)
        detachChild(router)
        addPaymentMethodRouting = nil
    }
    
    func attachTopup() {
        if topupRouting != nil {
            return
        }
        
        let router = topupBuilder.build(withListener: interactor)
        topupRouting = router
        attachChild(router)
    }
    
    func detachTopup() {
        guard let router = topupRouting else {
            return
        }
        
        detachChild(router)
        topupRouting = nil
    }
}

