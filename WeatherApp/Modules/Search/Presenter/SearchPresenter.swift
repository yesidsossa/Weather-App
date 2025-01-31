import Foundation

protocol SearchPresenterProtocol {
    func searchLocation(query: String)
    func didSelectLocation(location: Location)
}

class SearchPresenter: SearchPresenterProtocol {
    private let interactor: SearchInteractorProtocol
    private let view: SearchViewProtocol
    private let router: SearchRouterProtocol // Se agrega el Router

    init(interactor: SearchInteractorProtocol, view: SearchViewProtocol, router: SearchRouterProtocol) {
        self.interactor = interactor
        self.view = view
        self.router = router
    }

    func searchLocation(query: String) {
        guard !query.isEmpty else {
            view.showLocations([])
            return
        }

        interactor.fetchLocations(query: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let locations):
                    self?.view.showLocations(locations)
                case .failure(let error):
                    self?.view.showError(error.localizedDescription)
                }
            }
        }
    }

    func didSelectLocation(location: Location) {
        router.navigateToWeatherDetails(from: view, location: location)
    }
}
