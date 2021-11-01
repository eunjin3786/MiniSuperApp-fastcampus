import ModernRIBs

protocol FinanceHomeInteractable: Interactable, SuperPayDashboardListener {
    var router: FinanceHomeRouting? { get set }
    var listener: FinanceHomeListener? { get set }
}

protocol FinanceHomeViewControllable: ViewControllable {
    func addDashboard(_ view: ViewControllable)
}

final class FinanceHomeRouter: ViewableRouter<FinanceHomeInteractable, FinanceHomeViewControllable>, FinanceHomeRouting {
    
    private let superPayDashboardBuilder: SuperPayDashboardBuildable
    private var superPayRouting: Routing?
    
    init(interactor: FinanceHomeInteractable,
                  viewController: FinanceHomeViewControllable,
                  superPayDashboardBuilder: SuperPayDashboardBuildable) {
        self.superPayDashboardBuilder = superPayDashboardBuilder
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
}
