//
//  Presenter.swift
//  DZ20
//
//  Created by Dmitriy on 11/20/22.
//

import Foundation

//object
//protocol
//ref to view, interactor, presenter

protocol AnyPresenter {
    var view: AnyView? { get set }
    var interactor: AnyInteractor? { get set }
    var router: AnyRouter? { get set }
    
    func interactorDidFetchCats(with result: Result<[Cat], Error>)
}

class CatPresenter: AnyPresenter {
    var view: AnyView?
    var interactor: AnyInteractor? {
        didSet {
            interactor?.getCats()
        }
    }
    var router: AnyRouter?
    
    func interactorDidFetchCats(with result: Result<[Cat], Error>) {
        switch result {
        case .success(let cats):
            view?.update(with: cats)
        case .failure(_):
            view?.update(with: "Something went wrong")
        }
    }
}
