//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Даниил Лапышов on 9.11.2024.
//

import UIKit
struct AlertModel {
    let title: String
    let messege: String
    let buttonText: String
    let completion: (() -> Void)?
}


