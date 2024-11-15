//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Даниил Лапышов on 8.11.2024.
//

import Foundation
protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
