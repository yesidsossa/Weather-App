import XCTest
@testable import WeatherApp

class WeatherDetailsPresenterTests: XCTestCase {
    var presenter: WeatherDetailsPresenter!
    var mockInteractor: WeatherDetailsInteractor!
    var mockView: MockWeatherDetailsView!
    var mockRepository: MockWeatherRepository!
    var mockCoordinator: MockWeatherDetailsCoordinator!

    override func setUp() {
        super.setUp()
        mockRepository = MockWeatherRepository()
        mockInteractor = WeatherDetailsInteractor(repository: mockRepository)
        mockView = MockWeatherDetailsView()
        mockCoordinator = MockWeatherDetailsCoordinator()  
        presenter = WeatherDetailsPresenter(interactor: mockInteractor, view: mockView, location: "New York", coordinator: mockCoordinator) 
    }

    func testLoadWeatherDetails_Success() {
        let expectedWeatherDetails = WeatherDetails(
            location: LocationInfo(name: "New York", country: "USA"),
            current: CurrentWeather(temp_c: 20.5, condition: WeatherCondition(text: "Clear", icon: "//cdn.weatherapi.com/icon.png")),
            forecast: ForecastInfo(forecastday: [])
        )

        mockRepository.mockWeatherDetails = expectedWeatherDetails

        presenter.loadWeatherDetails()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.mockView.weatherDetailsReceived?.location.name, "New York")
            XCTAssertEqual(self.mockView.weatherDetailsReceived?.current.temp_c, 20.5)
        }
    }


    func testLoadWeatherDetails_Failure() {
        mockRepository.shouldReturnError = true
        presenter.loadWeatherDetails()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertNotNil(self.mockView.errorMessageReceived, "Se esperaba un mensaje de error")
            XCTAssertEqual(self.mockView.errorMessageReceived, "Error simulado")
        }
    }


    func testNavigateBack_CallsCoordinator() {
        presenter.navigateBack()
        XCTAssertTrue(mockCoordinator.didNavigateBack, "El coordinador debería haber manejado la navegación de regreso")
    }

}
