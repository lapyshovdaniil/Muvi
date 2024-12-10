//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Даниил Лапышов on 9.11.2024.
//

import UIKit

final class AlertPresenter {
    weak var delegate : UIViewController?
    func setDelegate(_ delegate: UIViewController){
        self.delegate = delegate
    }
    private func newAlertModel(model: AlertModel) -> UIAlertController {
        let alert = UIAlertController(title: model.title, message: model.messege, preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "Game results"
        let action = UIAlertAction(title: model.buttonText, style: .default) {_ in model.completion?()
        }
        alert.addAction(action)
        return alert
    }
    func shownewAlert(model:AlertModel) {
        let alert = newAlertModel(model: model)
        delegate?.present(alert, animated: true, completion: nil)
    }
}
