//
//  Router.swift
//  DZ20
//
//  Created by Dmitriy on 12/22/22.
//

import UIKit

//object
//entry point

protocol RandRouterProtocol {
    var view: RandViewProtocol? { get set }

    static func createModule() -> RandRouterProtocol
}

class RandRouter: RandRouterProtocol {

    var view: RandViewProtocol?

    static func createModule() -> RandRouterProtocol {
        let router = RandRouter()
        let view = RandViewController()
        let interactor = RandInteractor()
        let presenter = RandPresenter()

        view.presenter = presenter
        interactor.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.view = view

        return router
    }
}
