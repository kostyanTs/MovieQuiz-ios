//
//  AllertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Konstantin on 23.01.2024.
//

import Foundation

protocol AllertPresenterProtocol {
    var delegate: AllertPresenterDelegate?{ get set }
    func createAllertModel(correctAnswers: Int) -> AllertModel
}
