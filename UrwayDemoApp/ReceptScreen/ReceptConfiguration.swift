//
//  ReceptConfiguration.swift
//  UrwayDemoApp
//

import Foundation
import UIKit



func getController(_ storyBoardName: String, _ identifier: String) -> UIViewController {
    return UIStoryboard(name: storyBoardName, bundle: nil).instantiateViewController(withIdentifier: identifier)
}

class ReceptConfiguration {
    static func setup(parameters: [String: Any] = [:]) -> ReceptViewController {
        guard let controller = getController("Main", "ReceptViewController") as? ReceptViewController else {return ReceptViewController()}
        let router = ReceptRouter(view: controller)
        let presenter = ReceptPresenter(view: controller)
        let manager = ReceptManager()
        let interactor = ReceptInteractor(presenter: presenter, manager: manager)
        
        controller.interactor = interactor
        controller.router = router
        interactor.parameters = parameters
        return controller
    }
}
