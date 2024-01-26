//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Konstantin on 23.01.2024.
//

import Foundation


final class StatisticServiceImplementation: StatisticService {
    
    private let userDefaults = UserDefaults.standard
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    var totalAccuracy: Double {
        get {
            return userDefaults.double(forKey: Keys.total.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    var gamesCount: Int  {
        get {
            return userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
                
            }
            return record
        }

        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        self.gamesCount += 1
        let bestRecord = GameRecord(correct: count, total: amount, date: Date())
        if bestRecord.isBetterThan(bestGame) {
            self.bestGame = bestRecord
        }
        var correctAnswers = userDefaults.integer(forKey: Keys.correct.rawValue)
        correctAnswers += count
        userDefaults.set(correctAnswers, forKey: Keys.correct.rawValue)
        totalAccuracy = Double((correctAnswers / gamesCount) * 10)
    }

}
