//
//  MovieQuizViewControllerTests.swift
//  MovieQuizTests
//
//  Created by Даниил Лапышов on 10.12.2024.
//

import XCTest
@testable import MovieQuiz
final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func showLoadingIndicator() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
    
    func highlightImageBorder(isCorrect: Bool) {
        
    }
    
    func frameUpdata() {
        
    }
    
    func show(quiz step: QuizStepViewModel) {
        
    }
    
    func showAlert(message: String) {
        
    }
    
    func showNetworkError(message: String) {
        
    }
}
final class MovieQuizViewControllerTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
