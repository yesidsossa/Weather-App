import UIKit
import Lottie

protocol SplashViewProtocol: AnyObject {
    func navigateToSearch()
}

class SplashViewController: UIViewController, SplashViewProtocol {
    var presenter: SplashPresenterProtocol?

    private let animationView: LottieAnimationView = {
        guard let animationURL = Bundle.main.url(forResource: "splash_animation", withExtension: "json") else {
            fatalError("No se encontró el archivo JSON de la animación en Resources/Assets")
        }
        let animation = LottieAnimationView(filePath: animationURL.path)
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .playOnce
        animation.accessibilityIdentifier = "splashAnimation"
        animation.translatesAutoresizingMaskIntoConstraints = false
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
            self?.navigateToSearch()
        }
    }

    func navigateToSearch() {
        presenter?.navigateToSearch()
    }
}
