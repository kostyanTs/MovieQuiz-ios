//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Konstantin on 22.01.2024.
//

import Foundation

protocol QuestionFactoryProtocol {
    var delegate: QuestionFactoryDelegate?{ get set }
    func requestNextQuestion()
    func loadData()
} 
