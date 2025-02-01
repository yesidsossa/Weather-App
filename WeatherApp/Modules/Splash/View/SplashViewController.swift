import UIKit
import Lottie

protocol SplashViewProtocol: AnyObject {}

class SplashViewController: UIViewController, SplashViewProtocol {
    var presenter: SplashPresenterProtocol?

    private let animationView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "splash_animation")
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .playOnce
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.accessibilityIdentifier = "splashAnimation"
        return animation
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        startAnimation()
    }

    private func setupUI() {
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 200),
            animationView.heightAnchor.constraint(equalToConstant: 200)

        ])
    }

    private func startAnimation() {
        animationView.play { [weak self] _ in
            self?.presenter?.startSplash()
        }
    }
}
