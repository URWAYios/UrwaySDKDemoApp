//
//  PaymentRouter.swift
//  Urway
//
//  Copyright (c) 2020 URWAY. All rights reserved.

import UIKit

protocol IPaymentRouter: class {
	// do someting...
}

class PaymentRouter: IPaymentRouter {	
	weak var view: PaymentViewController?
	
	init(view: PaymentViewController?) {
		self.view = view
	}
}
