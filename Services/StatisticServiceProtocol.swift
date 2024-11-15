//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Даниил Лапышов on 12.11.2024.
//

import Foundation
protocol StatisticServiceProtocol{
    var gamesCount: Int { get }
    var bestGame : GameResult { get }
    var totalAccuracy: Double { get }
    func store(correct count: Int, total amount: Int)
}
