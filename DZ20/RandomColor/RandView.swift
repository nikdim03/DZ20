//
//  View.swift
//  DZ20
//
//  Created by Dmitriy on 12/22/22.
//

import UIKit

//view controller
//protocol
//ref to presenter

protocol RandViewProtocol {
    var presenter: RandPresenterProtocol? { get set }
    func updateBackgroundColor(_ color: UIColor)
}

class RandViewController: UIViewController {
    var presenter: RandPresenterProtocol?
    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Color", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    @objc private func buttonTapped(_ sender: UIButton) {
        presenter?.buttonTapped()
    }
}

// MARK: - RandViewProtocol
extension RandViewController: RandViewProtocol {
    func updateBackgroundColor(_ color: UIColor) {
        view.backgroundColor = color
    }
}
