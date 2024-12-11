//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Даниил Лапышов on 10.12.2024.
//

import Foundation
protocol MovieQuizViewControllerProtocol: AnyObject{
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func highlightImageBorder(isCorrect: Bool)
    func frameUpdata()
    func show(quiz step: QuizStepViewModel)
    func showAlert(message: String)
    func showNetworkError(message: String)
}
