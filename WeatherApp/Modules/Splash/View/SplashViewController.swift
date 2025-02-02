import UIKit
import Lottie

protocol SplashViewProtocol: AnyObject {}

class SplashViewController: UIViewController, SplashViewProtocol {
    var presenter: SplashPresenterProtocol?

    // MARK: - UI Elements
    private let animationView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "splash_animation")
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .playOnce
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.accessibilityIdentifier = "splashAnimation"
        return animation
    }()

    private lazy var appTitleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationManager.localizedString(forKey: LocalizedKeys.Splash.appTitleLabel)
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var sloganLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationManager.localizedString(forKey: LocalizedKeys.Splash.sloganLabel)
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        startAnimation()
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(animationView)
        view.addSubview(appTitleLabel)
        view.addSubview(sloganLabel)

        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            animationView.widthAnchor.constraint(equalToConstant: 200),
            animationView.heightAnchor.constraint(equalToConstant: 200),

            appTitleLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 20),
            appTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            sloganLabel.topAnchor.constraint(equalTo: appTitleLabel.bottomAnchor, constant: 8),
            sloganLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // MARK: - Start Animation
    private func startAnimation() {
        animationView.play { [weak self] _ in
            self?.animateTextAppearance()
        }
    }

    private func animateTextAppearance() {
        UIView.animate(withDuration: 0.8, animations: {
            self.appTitleLabel.alpha = 1
            self.sloganLabel.alpha = 1
        }) { _ in
            self.transitionToNextScreen()
        }
    }

    private func transitionToNextScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.presenter?.startSplash()
        }
    }
}
