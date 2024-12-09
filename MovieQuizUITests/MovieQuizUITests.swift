//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Даниил Лапышов on 3.12.2024.
//

import XCTest

class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    func testYesButton() {
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["Yes"].tap()
        sleep(3)
        let indexLabe = app.staticTexts["Index"]
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertEqual(indexLabe.label, "2/10")
        XCTAssertFalse(firstPoster == secondPoster)
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    func testNoButton() {
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        sleep(3)
        let indexLabe = app.staticTexts["Index"]
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertEqual(indexLabe.label, "2/10")
        XCTAssertFalse(firstPoster == secondPoster)
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    func testAlertPresent() {
        sleep(2)
        var i = 0
        repeat {
            app.buttons["No"].tap()
            i += 1
            sleep(2)
        } while i != 10
        let alert = app.alerts["Game results"]
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть еще раз")
    }
    func testAlertDismiss(){
        sleep(2)
        var i = 0
        repeat {
            app.buttons["No"].tap()
            i += 1
            sleep(2)
        } while i != 10
        let alert = app.alerts["Game results"]
        alert.buttons.firstMatch.tap()
        sleep(2)
        let indexLabel = app.staticTexts["Index"]
           XCTAssertFalse(alert.exists)
           XCTAssertTrue(indexLabel.label == "1/10")
    }
    override func setUpWithError() throws {
        try super.setUpWithError()
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
         app = nil

    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

    }
}
