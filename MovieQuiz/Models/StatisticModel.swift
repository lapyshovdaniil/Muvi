//
//  StatisticModel.swift
//  MovieQuiz
//
//  Created by Даниил Лапышов on 13.11.2024.
//

import UIKit
struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    func isBetterThan(_ value: GameResult) -> Bool{
        correct > value.correct
    }
}
