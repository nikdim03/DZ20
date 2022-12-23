//
//  Interactor.swift
//  DZ20
//
//  Created by Dmitriy on 12/22/22.
//

import UIKit

protocol RandInteractorProtocol {
    var presenter: RandPresenterProtocol? { get set }
    func generateRandomColor()
}

class RandInteractor: RandInteractorProtocol {
    var presenter: RandPresenterProtocol?
    func generateRandomColor() {
        let color = UIColor(red: CGFloat.random(in: 0...1),
                            green: CGFloat.random(in: 0...1),
                            blue: CGFloat.random(in: 0...1),
                            alpha: 1)
        self.presenter?.didGenerateRandomColor(color)
    }
}
