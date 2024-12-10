//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Даниил Лапышов on 9.12.2024.
//

import UIKit

final class MovieQuizPresenter {
    var questionFactory: QuestionFactoryProtocol?
    private let statisticService = StatisticService()
    private var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    var correntAnswers = 0
    let questionsAmount: Int = 10
    private var currentQuestionIndex = 0
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    func restartGame() {
        currentQuestionIndex = 0
        correntAnswers = 0
    }
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    func didAnswers(isCorroctAnswer: Bool){
            correntAnswers += 1
    }
     func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = isYes
        
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    internal func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            statisticService.store(correct: correntAnswers, total: self.questionsAmount)
            let text = "Ваш результат: \(correntAnswers)/\(statisticService.bestGame.total)\n" + " Количество сыгранных квизов: \(statisticService.gamesCount)\n" + "Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) \(statisticService.bestGame.date.dateTimeString)\n" + "Средняя точность: \(String(format: "%.2f",statisticService.totalAccuracy))%"
            viewController?.showAlert(message: text)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
}

