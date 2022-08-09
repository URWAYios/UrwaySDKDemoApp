//
//  PaymentPresenter.swift
//  Urway
//
//  Copyright (c) 2020 URWAY. All rights reserved.

import UIKit

protocol IPaymentPresenter: class {
	// do someting...
    
    func apiResult(result: paymentResult, response: [String: Any]?  , error: Error? )
}

class PaymentPresenter: IPaymentPresenter {
    
    weak var view: IPaymentViewController?
    
    init(view: IPaymentViewController?) {
        self.view = view
    }
    
  
    
    func apiResult(result: paymentResult,response: [String: Any]? ,  error: Error?) {
        view?.apiResult(result: result, response: response ,  error: error)
    }
}
