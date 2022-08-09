//
//  PaymentConfiguration.swift
//  Urway
//
//  Copyright (c) 2020 URWAY. All rights reserved.
 
import Foundation
import UIKit

class PaymentConfiguration {
    static func setup(parameters: [String: Any] = [:]) -> PaymentViewController {
        guard let controller = getController("Main", "PaymentViewController") as? PaymentViewController else {return PaymentViewController()}
        let router = PaymentRouter(view: controller)
        let presenter = PaymentPresenter(view: controller)
        let manager = PaymentManager()
        let interactor = PaymentInteractor(presenter: presenter, manager: manager)
        
        controller.interactor = interactor
        controller.router = router
        interactor.parameters = parameters
        return controller
    }
}
