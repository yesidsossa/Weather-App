import XCTest
@testable import WeatherApp

class WeatherDetailsPresenterTests: XCTestCase {
    var presenter: WeatherDetailsPresenter!
    var mockInteractor: WeatherDetailsInteractor!
    var mockView: MockWeatherDetailsView!
    var mockRepository: MockWeatherRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockWeatherRepository()
        mockInteractor = WeatherDetailsInteractor(repository: mockRepository)
        mockView = MockWeatherDetailsView()
        presenter = WeatherDetailsPresenter(interactor: mockInteractor, view: mockView, location: "New York")
    }

    func testLoadWeatherDetails_Success() {
        // Arrange
        let expectedWeatherDetails = WeatherDetails(
            location: LocationInfo(name: "New York", country: "USA"),
            current: CurrentWeather(temp_c: 20.5, condition: WeatherCondition(text: "Clear", icon: "//cdn.weatherapi.com/icon.png")),
            forecast: ForecastInfo(forecastday: [])
        )

        mockRepository.mockWeatherDetails = expectedWeatherDetails

        // Act
        presenter.loadWeatherDetails()

        // Assert (espera asincrónica para permitir que los datos se actualicen)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.mockView.weatherDetailsReceived?.location.name, "New York")
            XCTAssertEqual(self.mockView.weatherDetailsReceived?.current.temp_c, 20.5)
        }
    }

    func testLoadWeatherDetails_Failure() {
        // Arrange
        mockRepository.shouldReturnError = true

        // Act
        presenter.loadWeatherDetails()

        // Assert
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.mockView.errorMessageReceived, "Error simulado")
        }
    }
}
