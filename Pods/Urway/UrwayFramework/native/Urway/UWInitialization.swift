//
//  UWInitialization.swift
//  Urway
//
//  Copyright © 2020 URWAY. All rights reserved.
//

import Foundation
import UIKit

public enum paymentResult: Equatable {
    case sucess
    case failure(String)
    case mandatory(mandatoryEnum)
}

public enum mandatoryEnum {
    case amount
    case email
    case currency
    case country
    case action_code
    case trackId
    case tokenID
    case cardOperation
}

public protocol Initializer: UIViewController {
        func prepareModel() -> UWInitializer
        func didPaymentResult(result: paymentResult , error: Error? , model: PaymentResultData?)
}

public class UWInitialization {
    
    private var initProto: Initializer? = nil
    
    @discardableResult public init(_ parentController: UIViewController , onCompletion: ((UIViewController? , paymentResult) -> Void)? = nil)
    {

        guard let confirmedController = parentController as? Initializer else {return}
        self.initProto = confirmedController
        
        guard let model = initProto?.prepareModel() else {return}
        
        let result = Validator().checkMandatoryFields(for: model)

        if result != .sucess
        {
            onCompletion?(nil , result)
        }
        else
        {
            let controller = PaymentConfiguration.setup()
            controller.initModel = model
            controller.initProto = self.initProto
            onCompletion?(controller, result)
        }
    }
}


