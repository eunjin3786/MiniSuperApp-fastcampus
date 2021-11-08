//
//  EnterAmountViewController.swift
//  MiniSuperApp
//
//  Created by Jinny on 11/8/21.
//

import ModernRIBs
import UIKit

protocol EnterAmountPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class EnterAmountViewController: UIViewController, EnterAmountPresentable, EnterAmountViewControllable {

    weak var listener: EnterAmountPresentableListener?
}
