//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Konstantin on 21.02.2024.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    private var currentQuestionIndex = 0
    let questionsAmount: Int = 10
    var correctAnswers = 0
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    private var questionFactory: QuestionFactoryProtocol? = QuestionFactory(moviesLoader: MoviesLoader())
    private var statisticService: StatisticService = StatisticServiceImplementation()
    
    init(viewController: MovieQuizViewController) {
        questionFactory?.delegate = self
        self.viewController = viewController
        questionFactory?.loadData()
        questionFactory?.requestNextQuestion()
        viewController.showLoadingIndicator()
    }
    
    func didLoadDataFromServer() { // сообщение об успешной загрузке
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    func makeResultsMessage() -> String {
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        let bestGame = statisticService.bestGame
        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let currentGameResultLine = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)"
        + " (\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        
        let resultMessage = [
            currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
        ].joined(separator: "\n")
        
        return resultMessage
    }
    
    func proceedWithAnswerResult(isCorrect: Bool) {
        DidCorrectAnswer(isCorrectAnswer: isCorrect)
        viewController?.buttonsEnabled(isEnabled: false)
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                self.correctAnswers = self.correctAnswers
                self.proceedToNextQuestionOrResults()
            }
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
        
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
        
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func proceedToNextQuestionOrResults() {
        if self.isLastQuestion() {
            let text = "Вы ответили на \(correctAnswers) из 10 \n попробуйте ещё раз!\n"
            let viewModel = AllertModel(
                title: "Этот раунд окончен!",
                message: text,
                buttonText: "Сыграть ещё раз\n")
                viewController?.showAllert(quiz: viewModel)
            viewController?.buttonsEnabled(isEnabled: true)
        } else { // 2
            self.switchToNextQuestion()
            self.questionFactory?.requestNextQuestion()
            viewController?.buttonsEnabled(isEnabled: true)
        }
    }
    
    func  DidCorrectAnswer(isCorrectAnswer: Bool) {
        correctAnswers = isCorrectAnswer ? correctAnswers + 1 : correctAnswers
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = isYes
        proceedWithAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
}
