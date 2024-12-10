import UIKit
final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private weak var YesButton: UIButton!
    @IBOutlet private weak var NoButton: UIButton!
    @IBOutlet  private weak var counterLabel: UILabel!
    @IBOutlet  private weak var textLabel: UILabel!
    @IBOutlet  private weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var questionFactory: QuestionFactoryProtocol?
    private let presenter = MovieQuizPresenter()
    private var alertPresenter : AlertPresenter?
    private var statisticService: StatisticServiceProtocol = StatisticService()
 
    
    
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
    presenter.didReceiveNextQuestion(question: question)
   }
    

    
     func showAnswerResult(isCorrect: Bool) {
        presenter.didAnswers(isCorroctAnswer: isCorrect)
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        self.YesButton.isEnabled = false
        self.NoButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.YesButton.isEnabled = true
            self.NoButton.isEnabled = true
          
            self.presenter.questionFactory = self.questionFactory
            self.presenter.showNextQuestionOrResults()
            self.imageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    private func showNextQuestionOrResults() {
        presenter.showNextQuestionOrResults()
        
    }
  func show(quiz step: QuizStepViewModel){
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    @IBAction private func YesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    @IBAction private func NoButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
     func showAlert(message: String){
        let text = message
        let viewModel = AlertModel(title: "Этот раунд окончен!", messege: text, buttonText: "Сыграть еще раз", completion: { [weak self] in
            guard let self = self else { return }
            presenter.restartGame()
            questionFactory?.requestNextQuestion()
        })
        alertPresenter?.shownewAlert(model: viewModel)
    }
    
    
    private func showNetworkError(message: String) {
        
        let model = AlertModel(title: "Ошибка",
                               messege: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.presenter.restartGame()
            
            self.questionFactory?.requestNextQuestion()
        }
        
        alertPresenter?.shownewAlert(model: model)
    }
}

