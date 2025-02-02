import Foundation

protocol SearchPresenterProtocol {
    func searchLocation(query: String)
    func didSelectLocation(location: Location)
    func toggleFavorite(location: Location)
    func loadFavorites()
    func removeFavorite(location: FavoriteLocation)
}

class SearchPresenter: SearchPresenterProtocol {
    private let interactor: SearchInteractorProtocol
    private let view: SearchViewProtocol
    private let coordinator: SearchCoordinatorProtocol

    init(interactor: SearchInteractorProtocol, view: SearchViewProtocol, coordinator: SearchCoordinatorProtocol) {
        self.interactor = interactor
        self.view = view
        self.coordinator = coordinator
    }

    func searchLocation(query: String) {
        guard !query.isEmpty else {
            view.showLocations([])
            return
        }

        interactor.fetchLocations(query: query) { [weak self] result in
            DispatchQueue.main.async {
                self?.handleSearchResult(result)
            }
        }
    }

    private func handleSearchResult(_ result: Result<[Location], Error>) {
        switch result {
        case .success(let locations):
            view.showLocations(locations)
        case .failure(let error):
            view.showError(error.localizedDescription)
        }
    }

    func didSelectLocation(location: Location) {
        coordinator.navigateToWeatherDetails(for: location)
    }

    func toggleFavorite(location: Location) {
        let favorite = FavoriteLocation(name: location.name, country: location.country, temp: nil, icon: nil)
        
        if view.isFavorite(location: favorite) {
            interactor.removeFavorite(favorite) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.loadFavorites()
                    case .failure(let error):
                        self?.view.showError(error.localizedDescription)
                    }
                }
            }
        } else {
            interactor.addFavorite(location) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.loadFavorites()
                    case .failure(let error):
                        self?.view.showError(error.localizedDescription)
                    }
                }
            }
        }
    }


    func loadFavorites() {
        switch interactor.getFavorites() {
        case .success(let favorites):
            view.showFavorites(favorites)
        case .failure(let error):
            view.showError(error.localizedDescription)
        }
    }
    
    func removeFavorite(location: FavoriteLocation) {
        interactor.removeFavorite(location) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.loadFavorites()
                case .failure(let error):
                    self?.view.showError(error.localizedDescription)
                }
            }
        }
    }
}
