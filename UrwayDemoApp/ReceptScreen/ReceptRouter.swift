//
//  ReceptRouter.swift
//  UrwayDemoApp
//

import UIKit

protocol IReceptRouter: class {
	// do someting...
}

class ReceptRouter: IReceptRouter {	
	weak var view: ReceptViewController?
	
	init(view: ReceptViewController?) {
		self.view = view
	}
}
