import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AllertPresenterDelegate {

    // MARK: - Private outlets
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
//    private var currentQuestionIndex = 0
//    private let questionsAmount: Int = 10
    private var presenter = MovieQuizPresenter()
    private var questionFactory: QuestionFactoryProtocol = QuestionFactory(moviesLoader: MoviesLoader())
    private var allertPresenter: AllertPresenterProtocol = AllertPresenter()
    private var statisticService: StatisticService = StatisticServiceImplementation()
//    private var currentQuestion: QuizQuestion?
//    private var correctAnswers = 0
    private let gamesCountText: String = "Количество сыгранных квизов:"
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory.delegate = self
        allertPresenter.delegate = self
        questionFactory.requestNextQuestion()
        imageView.layer.cornerRadius = 20
        showLoadingIndicator()
        questionFactory.loadData()
        counterLabel.accessibilityIdentifier = "Index"
        presenter.viewController = self
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    private func showNetworkError(message: String) {
        activityIndicator.isHidden = true
        
        let model = AllertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз")
        let alert = UIAlertController(
            title: model.title,
            message: model.title,
            preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            presenter.resetQuestionIndex() 
            presenter.correctAnswers = 0
            questionFactory.requestNextQuestion()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func didLoadDataFromServer() { // сообщение об успешной загрузке
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) { // сообщение об ошибке загрузки
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
        
    }
    
    // MARK: - QuestionFactoryDelegate

    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }
    
    // MARK: - AllertPresenterDelegate
    
    func showAllert(quiz result: AllertModel) {
        statisticService.store(correct: presenter.correctAnswers, total: presenter.questionsAmount)
        let gameCountMessage = "\(gamesCountText) \(statisticService.gamesCount)\n"
        let recordMessage = "Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))\n"
        let totalAcuracyMessage = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        let newMessage = result.message + gameCountMessage + recordMessage + totalAcuracyMessage
        let alert = UIAlertController(
            title: result.title,
            message: newMessage,
            preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            presenter.resetQuestionIndex()
            presenter.correctAnswers = 0
            questionFactory.requestNextQuestion()
        }
        alert.addAction(action)
        alert.view.accessibilityIdentifier = "Game results"
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Private functions
    
//    private func convert(model: QuizQuestion) -> QuizStepViewModel {
//        return QuizStepViewModel(
//            image: UIImage(data: model.image) ?? UIImage(),
//            question: model.text,
//            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
//    }

    func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
        imageView.layer.borderWidth = 0
        imageView.layer.cornerRadius = 20
    }
    
//    private func showNextQuestionOrResults() {
//        if presenter.isLastQuestion() { // 1
//            buttonsEnabled(isEnabled: true)
//            let viewModel = allertPresenter.createAllertModel(correctAnswers: correctAnswers)
//            DispatchQueue.main.async { [weak self] in
//                self?.showAllert(quiz: viewModel)
//            }
//        } else { // 2
//            presenter.switchToNextQuestion()
//            self.questionFactory.requestNextQuestion()
//            buttonsEnabled(isEnabled: true)
//        }
//    }
    
    func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        presenter.correctAnswers = isCorrect ? presenter.correctAnswers + 1 : presenter.correctAnswers
        buttonsEnabled(isEnabled: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                self.presenter.correctAnswers = self.presenter.correctAnswers
                self.presenter.questionFactory = self.questionFactory
                self.presenter.showNextQuestionOrResults()
            }
    }
    
    func buttonsEnabled(isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    // MARK: - Private Actions
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter.noButtonClicked()
    }
}








