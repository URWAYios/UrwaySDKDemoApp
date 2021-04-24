//
//  ReceptPresenter.swift
//  UrwayDemoApp
//

import UIKit

protocol IReceptPresenter: class {
	// do someting...
}

class ReceptPresenter: IReceptPresenter {	
	weak var view: IReceptViewController?
	
	init(view: IReceptViewController?) {
		self.view = view
	}
}
