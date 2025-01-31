import Foundation

protocol SearchPresenterProtocol {
    func searchLocation(query: String)
    func didSelectLocation(location: Location)
    func loadFavorites()
    func removeFavorite(location: FavoriteLocation) 
}

class SearchPresenter: SearchPresenterProtocol {
    private let interactor: SearchInteractorProtocol
    private let view: SearchViewProtocol
    private let router: SearchRouterProtocol

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
        interactor.addFavorite(location)
        loadFavorites()
        router.navigateToWeatherDetails(from: view, location: location)
    }

    func loadFavorites() {
        let favorites = interactor.getFavorites()
        view.showFavorites(favorites)
    }

    func removeFavorite(location: FavoriteLocation) {
        interactor.removeFavorite(location)
        loadFavorites()
    }
}
