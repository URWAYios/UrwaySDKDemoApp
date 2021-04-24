//
//  ReceptInteractor.swift
//  UrwayDemoApp
//

import UIKit

protocol IReceptInteractor: class {
	var parameters: [String: Any]? { get set }
}

class ReceptInteractor: IReceptInteractor {
    var presenter: IReceptPresenter?
    var manager: IReceptManager?
    var parameters: [String: Any]?

    init(presenter: IReceptPresenter, manager: IReceptManager) {
    	self.presenter = presenter
    	self.manager = manager
    }
}
