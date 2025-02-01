import Foundation

protocol WeatherDetailsPresenterProtocol {
    func loadWeatherDetails()
    func navigateBack()
}

class WeatherDetailsPresenter: WeatherDetailsPresenterProtocol {
    func navigateBack() {
        coordinator.navigateBack()
    }
    
    private let interactor: WeatherDetailsInteractorProtocol
    private let view: WeatherDetailsViewProtocol
    private let location: String
    private let coordinator: WeatherDetailsCoordinatorProtocol

    init(interactor: WeatherDetailsInteractorProtocol, view: WeatherDetailsViewProtocol, location: String, coordinator: WeatherDetailsCoordinatorProtocol) {
        self.interactor = interactor
        self.view = view
        self.location = location
        self.coordinator = coordinator
    }

    func loadWeatherDetails() {
        interactor.fetchWeatherDetails(location: location) { [weak self] result in
            DispatchQueue.main.async {
                self?.handleWeatherDetailsResult(result)
            }
        }
    }

    private func handleWeatherDetailsResult(_ result: Result<WeatherDetails, Error>) {
        switch result {
        case .success(let details):
            view.showWeatherDetails(details)
        case .failure(let error):
            view.showError(error.localizedDescription) 
        }
    }

}
