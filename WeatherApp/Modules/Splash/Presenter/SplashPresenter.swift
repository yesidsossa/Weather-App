import Foundation

protocol SplashPresenterProtocol {
    func startSplash()
}

class SplashPresenter: SplashPresenterProtocol {
    private weak var view: SplashViewProtocol?
    private let interactor: SplashInteractorProtocol
    private let coordinator: SplashCoordinator

    init(view: SplashViewProtocol, interactor: SplashInteractorProtocol, coordinator: SplashCoordinator) {
        self.view = view
        self.interactor = interactor
        self.coordinator = coordinator
    }

    func startSplash() {
        interactor.loadInitialData { [weak self] in
            self?.coordinator.navigateToSearch()
        }
    }
}
