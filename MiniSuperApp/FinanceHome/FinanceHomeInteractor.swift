import ModernRIBs

protocol FinanceHomeRouting: ViewableRouting {
    func attachSuperPayDashboard()
    func attachCardOnFileDashboard()
    
    func attachAddPaymentMethod(closeButtonType: DismissButtonType)
    func detachAddPaymentMethod()
    
    func attachTopup()
    func detachTopup()
}

protocol FinanceHomePresentable: Presentable {
    var listener: FinanceHomePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol FinanceHomeListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class FinanceHomeInteractor: PresentableInteractor<FinanceHomePresentable>, FinanceHomeInteractable, FinanceHomePresentableListener, AdaptivePresentationControllerDelegate {
    
    weak var router: FinanceHomeRouting?
    weak var listener: FinanceHomeListener?
    
    let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: FinanceHomePresentable) {
        self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        super.init(presenter: presenter)
        presenter.listener = self
        presentationDelegateProxy.delegate = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        router?.attachSuperPayDashboard()
        router?.attachCardOnFileDashboard()
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    // MARK: - AdaptivePresentationControllerDelegate
    func presentationControllerDidDismiss() {
        router?.detachAddPaymentMethod()
    }
    
    // MARK: - CardOnFileDashboardListener
    func cardOnFileDashboardDidTapAddPaymentMethod() {
        router?.attachAddPaymentMethod(closeButtonType: .back)
    }
    
    // MARK: - SuperPayDashboardListener
    func superPayDashBoardDidTapTopup() {
        router?.attachTopup()
    }
    
    // MARK: - AddPaymentMethodListener
    func addPaymentMethodDidTapClose() {
        router?.detachAddPaymentMethod()
    }
    
    func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod) {
        router?.detachAddPaymentMethod()
    }
    
    // MARK: - TopupListener
    func topupDidClose() {
        router?.detachTopup()
    }
    
    func topupDidFinish() {
        router?.detachTopup()
    }
}
