//
//  Router.swift
//  DZ20
//
//  Created by Dmitriy on 11/20/22.
//

import UIKit

//object
//entry point

typealias EntryPoint = AnyView & UIViewController

protocol AnyRouter {
    var entry: EntryPoint? { get } //view
    static func start() -> AnyRouter
}

class CatRouter: AnyRouter {
    var entry: EntryPoint?
    static func start() -> AnyRouter {
        let router = CatRouter()
        
        var view: AnyView = CatViewController()
        var interactor: AnyInteractor = CatInteractor()
        var presenter: AnyPresenter = CatPresenter()

        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        router.entry = view as? EntryPoint
        
        return router
    }
}
