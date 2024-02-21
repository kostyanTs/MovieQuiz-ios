//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Konstantin on 21.02.2024.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func showAllert(quiz result: AllertModel)
    func highlightImageBorder(isCorrectAnswer: Bool)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showNetworkError(message: String)
}
