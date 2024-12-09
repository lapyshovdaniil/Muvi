import UIKit
final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private weak var YesButton: UIButton!
    @IBOutlet private weak var NoButton: UIButton!
    @IBOutlet  private weak var counterLabel: UILabel!
    @IBOutlet  private weak var textLabel: UILabel!
    @IBOutlet  private weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private let presenter = MovieQuizPresenter()
    private var alertPresenter : AlertPresenter?
    private var statisticService: StatisticServiceProtocol = StatisticService()
    private var correntAnswers = 0
    
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticService()
        showLoadingIndicator()
        questionFactory?.loadData()
        questionFactory?.requestNextQuestion()
        imageView.contentMode = .scaleAspectFill
        self.alertPresenter = AlertPresenter()
        alertPresenter?.setDelegate(self)
        presenter.viewController = self
    }
    // MARK: - QuestionFactoryDelegate
    internal func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    

    
     func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correntAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        self.YesButton.isEnabled = false
        self.NoButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            self.YesButton.isEnabled = true
            self.NoButton.isEnabled = true
            self.showNextQuestionOrResults()
            self.imageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    private func showNextQuestionOrResults() {
        if presenter.isLastQuestion() {
            statisticService.store(correct: correntAnswers, total: presenter.questionsAmount)
            let text = "Ваш результат: \(correntAnswers)/\(statisticService.bestGame.total)\n" + " Количество сыгранных квизов: \(statisticService.gamesCount)\n" + "Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) \(statisticService.bestGame.date.dateTimeString)\n" + "Средняя точность: \(String(format: "%.2f",statisticService.totalAccuracy))%"
            let viewModel = AlertModel(title: "Этот раунд окончен!", messege: text, buttonText: "Сыграть еще раз", completion: { [weak self] in
                guard let self = self else { return }
                self.presenter.resetQuestionIndex()
                self.correntAnswers = 0
                questionFactory?.requestNextQuestion()})
            alertPresenter?.shownewAlert(model: viewModel)
        } else {
            presenter.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    private func show(quiz step: QuizStepViewModel){
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    @IBAction private func YesButtonClicked(_ sender: UIButton) {
        presenter.currentQuestion = currentQuestion
        presenter.yesButtonClicked()
    }
    @IBAction private func NoButtonClicked(_ sender: UIButton) {
        presenter.currentQuestion = currentQuestion
        presenter.noButtonClicked()
    }
    private func showNetworkError(message: String) {
        
        let model = AlertModel(title: "Ошибка",
                               messege: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.presenter.resetQuestionIndex()
            self.correntAnswers = 0
            
            self.questionFactory?.requestNextQuestion()
        }
        
        alertPresenter?.shownewAlert(model: model)
    }
}

