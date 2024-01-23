//
//  AllertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Konstantin on 23.01.2024.
//

import Foundation


protocol AllertPresenterDelegate: AnyObject {
    func showAllert(quiz result: AllertModel)
}

