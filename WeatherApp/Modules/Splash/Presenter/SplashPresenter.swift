import Foundation

protocol SplashPresenterProtocol {
    func startSplash()
    func navigateToSearch()
}

class SplashPresenter: SplashPresenterProtocol {
    private weak var view: SplashViewProtocol?
    private let interactor: SplashInteractorProtocol
    private let router: SplashRouterProtocol

    init(view: SplashViewProtocol, interactor: SplashInteractorProtocol, router: SplashRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func startSplash() {
        interactor.loadInitialData { [weak self] in
            self?.view?.navigateToSearch()  
        }
    }

    func navigateToSearch() {
        router.navigateToSearch()
    }
}
