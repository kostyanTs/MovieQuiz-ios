//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Konstantin on 22.01.2024.
//

import Foundation



protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)   
}
