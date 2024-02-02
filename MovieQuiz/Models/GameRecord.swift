//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Konstantin on 23.01.2024.
//

import Foundation

struct GameRecord: Codable {
    var correct: Int
    var total: Int
    var date: Date
    
    // метод сравнения по количеству верных ответов
    func isBetterThan(_ another: GameRecord) -> Bool {
        correct > another.correct
    }
}
