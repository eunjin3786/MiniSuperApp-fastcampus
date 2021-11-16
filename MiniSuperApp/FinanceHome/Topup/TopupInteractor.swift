//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by Jinny on 11/8/21.
//

import ModernRIBs

protocol TopupRouting: Routing {
    func cleanupViews()
    
    func attachAddPaymentMethod()
    func detachAddPaymentMethod()
    
    func attachEnterAmount()
    func detachEnterAmount()
    
    func attachCardOnFile(paymentMethods: [PaymentMethod])
    func detachCardOnFile()
}

protocol TopupListener: AnyObject {
    func topupDidClose()
    func topupDidFinish()
}

protocol TopupInteractorDependency {
    var cardOnFileRepository: CardOnFileRepository { get }
    var paymentMethodStream: CurrentValuePublisher<PaymentMethod> { get }
}

final class TopupInteractor: Interactor, TopupInteractable, AdaptivePresentationControllerDelegate {

    weak var router: TopupRouting?
    weak var listener: TopupListener?

    private let dependency: TopupInteractorDependency
    let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    
    private var paymentMethods: [PaymentMethod] {
        dependency.cardOnFileRepository.cardOnFile.value
    }
    
    init(dependency: TopupInteractorDependency) {
        self.dependency = dependency
        self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        super.init()
        self.presentationDelegateProxy.delegate = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        if let card = dependency.cardOnFileRepository.cardOnFile.value.first {
            dependency.paymentMethodStream.send(card)
            // 금액 입력
            router?.attachEnterAmount()
        } else {
            // 카드 추가
            router?.attachAddPaymentMethod()
        }
    }

    override func willResignActive() {
        super.willResignActive()

        router?.cleanupViews()
    }
    
    // MARK: - AdaptivePresentationControllerDelegate
    func presentationControllerDidDismiss() {
        listener?.topupDidClose()
    }
    
    func addPaymentMethodDidTapClose() {
        router?.detachAddPaymentMethod()
        listener?.topupDidClose()
    }
    
    func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod) {
        
    }
    
    func enterAmountDidTapClose() {
        router?.detachEnterAmount()
        listener?.topupDidClose()
    }
    
    func enterAmountDidTapPaymentMethod() {
        router?.attachCardOnFile(paymentMethods: paymentMethods)
    }

    func enterAmountDidFinishTopup() {
        router?.detachEnterAmount()
        listener?.topupDidFinish()
    }
    
    func cardOnFileDidTapClose() {
        router?.detachCardOnFile()
    }
    
    func cardOnFileDidTapAddCard() {
        // attach add card
    }
    
    func cardOnFileDidSelect(at index: Int) {
        if let selected = paymentMethods[safe: index] {
            dependency.paymentMethodStream.send(selected)
        }
        
        router?.detachCardOnFile()
    }
}
