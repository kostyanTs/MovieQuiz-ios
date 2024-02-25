import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol, AllertPresenterDelegate {

    // MARK: - Private outlets
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var presenter: MovieQuizPresenter!
    private var allertPresenter: AllertPresenterProtocol = AllertPresenter()
    private let gamesCountText: String = "Количество сыгранных квизов:"
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allertPresenter.delegate = self
        presenter = MovieQuizPresenter(viewController: self)
        imageView.layer.cornerRadius = 20
        showLoadingIndicator()
        counterLabel.accessibilityIdentifier = "Index"
    }
    
    func showLoadingIndicator() {
        activityIndicator?.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator?.startAnimating() // включаем анимацию
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func showNetworkError(message: String) {
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
//            presenter.resetQuestionIndex()
            presenter.restartGame()
//            questionFactory.requestNextQuestion()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - AllertPresenterDelegate
    
    func showAllert(quiz result: AllertModel) {
        let message = presenter.makeResultsMessage()
        let alert = UIAlertController(
            title: result.title,
            message: message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            presenter.restartGame()
        }
        alert.addAction(action)
        alert.view.accessibilityIdentifier = "Game results"
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Private functions

    func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
        imageView.layer.borderWidth = 0
        imageView.layer.cornerRadius = 20
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
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








