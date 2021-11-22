import ModernRIBs
import FinanceRepository
import RIBsUtil
import CombineUtil
import AddPaymentMethod
import Topup

public protocol FinanceHomeDependency: Dependency {
    var cardOnFileRepository: CardOnFileRepository { get }
    var superPayRepository: SuperPayRepository { get }
    var topupBuildable: TopupBuildable { get }
    var addPaymentMethodBuilable: AddPaymentMethodBuildable { get }
}

final class FinanceHomeComponent: Component<FinanceHomeDependency>, SuperPayDashboardDependency, CardOnFileDashboardDependency {
    
    var balance: ReadOnlyCurrentValuePublisher<Double> { superPayRepository.balance }
  
    var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
    var superPayRepository: SuperPayRepository { dependency.superPayRepository }
    
    var topupBuildable: TopupBuildable { dependency.topupBuildable }
    var addPaymentMethodBuilable: AddPaymentMethodBuildable { dependency.addPaymentMethodBuilable }
}

// MARK: - Builder

public protocol FinanceHomeBuildable: Buildable {
    func build(withListener listener: FinanceHomeListener) -> ViewableRouting
}

public final class FinanceHomeBuilder: Builder<FinanceHomeDependency>, FinanceHomeBuildable {
    
    public override init(dependency: FinanceHomeDependency) {
        super.init(dependency: dependency)
    }
    
    public func build(withListener listener: FinanceHomeListener) -> ViewableRouting {
        let viewController = FinanceHomeViewController()
        let component = FinanceHomeComponent(dependency: dependency)
        let interactor = FinanceHomeInteractor(presenter: viewController)
        interactor.listener = listener
        let superPayDashboardBuilder = SuperPayDashboardBuilder(dependency: component)
        let cardOnFileDashboardBuilder = CardOnFileDashboardBuilder(dependency: component)
        let addPaymentMethodBuilder = component.addPaymentMethodBuilable
        let topupBuilder = component.topupBuildable
        return FinanceHomeRouter(interactor: interactor,
                                 viewController: viewController,
                                 superPayDashboardBuilder: superPayDashboardBuilder,
                                 cardOnFileDashboardBuilder: cardOnFileDashboardBuilder,
                                 addPaymentMethodBuilder: addPaymentMethodBuilder,
                                 topupBuilder: topupBuilder)
    }
}
