import UIKit
final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    @IBOutlet  private weak var YesButton: UIButton!
    @IBOutlet  private weak var NoButton: UIButton!
    @IBOutlet  private weak var counterLabel: UILabel!
    @IBOutlet  private weak var textLabel: UILabel!
    @IBOutlet  private weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter!
    private var alertPresenter : AlertPresenter?
    private var statisticService: StatisticServiceProtocol = StatisticService()
    
    
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        statisticService = StatisticService()
        showLoadingIndicator()
        imageView.contentMode = .scaleAspectFill
        self.alertPresenter = AlertPresenter()
        alertPresenter?.setDelegate(self)
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    func highlightImageBorder(isCorrect: Bool) {
        presenter.didAnswers(isCorroctAnswer: isCorrect)
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        self.YesButton.isEnabled = false
        self.NoButton.isEnabled = false
        
    }
    func frameUpdata() {
        self.imageView.layer.borderColor = UIColor.clear.cgColor
        self.YesButton.isEnabled = true
        self.NoButton.isEnabled = true
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
        let message = message
        let viewModel = AlertModel(title: "Этот раунд окончен!", messege: message, buttonText: "Сыграть еще раз", completion: { [weak self] in
            guard let self = self else { return }
            presenter.restartGame()
        })
        alertPresenter?.shownewAlert(model: viewModel)
    }
    
    func showNetworkError(message: String) {
        
        let model = AlertModel(title: "Ошибка",
                               messege: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.presenter.restartGame()
        }
        alertPresenter?.shownewAlert(model: model)
    }
}

