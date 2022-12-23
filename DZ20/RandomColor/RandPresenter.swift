//
//  Presenter.swift
//  DZ20
//
//  Created by Dmitriy on 12/22/22.
//

import UIKit

//object
//protocol
//ref to view, interactor, presenter

protocol RandPresenterProtocol {
    var view: RandViewProtocol? { get set }
    var interactor: RandInteractorProtocol? { get set }
    var router: RandRouterProtocol? { get set }

    func buttonTapped()
    func didGenerateRandomColor(_ color: UIColor)
}

class RandPresenter: RandPresenterProtocol {
    var view: RandViewProtocol?
    var interactor: RandInteractorProtocol?
    var router: RandRouterProtocol?
    func buttonTapped() {
        interactor?.generateRandomColor()
    }
    func didGenerateRandomColor(_ color: UIColor) {
        view?.updateBackgroundColor(color)
    }
}
