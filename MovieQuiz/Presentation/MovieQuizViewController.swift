import UIKit
final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private weak var YesButton: UIButton!
    @IBOutlet private weak var NoButton: UIButton!
    @IBOutlet  private weak var counterLabel: UILabel!
    @IBOutlet  private weak var textLabel: UILabel!
    @IBOutlet  private weak var imageView: UIImageView!
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex = 0
    private var correntAnswers = 0
    private var alertPresenter : AlertPresenter?
    private var statisticService: StatisticServiceProtocol = StatisticService()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        statisticService = StatisticService()
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleAspectFill
        let questionFactory = QuestionFactory() // 2
        questionFactory.delegate = self         // 3
        self.questionFactory = questionFactory  // 4
        questionFactory.requestNextQuestion()
        self.alertPresenter = AlertPresenter()
        alertPresenter?.setDelegate(self)
    }
    // MARK: - QuestionFactoryDelegate
    internal func didReceiveNextQuestion(question: QuizQuestion?) {
        
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
        return questionStep
    }
   private func showAnswerResult(isCorrect: Bool) {
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
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService.store(correct: correntAnswers, total: questionsAmount)
            let text = "Ваш результат: \(correntAnswers)/\(statisticService.bestGame.total)\n" + " Количество сыгранных квизов: \(statisticService.gamesCount)\n" + "Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) \(statisticService.bestGame.date.dateTimeString)\n" + "Средняя точность: \(String(format: "%.2f",statisticService.totalAccuracy))%"
            let viewModel = AlertModel(title: "Этот раунд окончен", messege: text, buttonText: "Сыграть еще раз", completion: { [weak self] in
                guard let self = self else { return }
                self.currentQuestionIndex = 0
                self.correntAnswers = 0
                questionFactory?.requestNextQuestion()})
            alertPresenter?.shownewAlert(model: viewModel)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    private func show(quiz step: QuizStepViewModel){
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    @IBAction private func YesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    @IBAction private func NoButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
}
