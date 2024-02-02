//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Konstantin on 23.01.2024.
//

import UIKit


final class AllertPresenter: UIViewController, AllertPresenterProtocol{
  
    var delegate: AllertPresenterDelegate?
    private let buttonText: String = "Сыграть еще раз"
    private let resultText: String = "Ваш результат:"
    private let resultTitleText: String = "Этот раунд окончен!"
 
    func createAllertModel(correctAnswers: Int) -> AllertModel {
        let text = "\(resultText) \(correctAnswers)/10\n"
        return AllertModel(title: self.resultTitleText,
                           message: text,
                           buttonText: self.buttonText)
    }
    

    

    

    
    
    
}
