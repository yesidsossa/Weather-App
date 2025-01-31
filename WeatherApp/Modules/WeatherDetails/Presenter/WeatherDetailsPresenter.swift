import Foundation

protocol WeatherDetailsPresenterProtocol {
    func loadWeatherDetails()
}

class WeatherDetailsPresenter: WeatherDetailsPresenterProtocol {
    private let interactor: WeatherDetailsInteractorProtocol
    private let view: WeatherDetailsViewProtocol
    private let location: String

    init(interactor: WeatherDetailsInteractorProtocol, view: WeatherDetailsViewProtocol, location: String) {
        self.interactor = interactor
        self.view = view
        self.location = location
    }

    func loadWeatherDetails() {
        interactor.fetchWeatherDetails(location: location) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let details):
                    self?.view.showWeatherDetails(details)
                case .failure(let error):
                    self?.view.showError(error.localizedDescription)
                }
            }
        }
    }
}
