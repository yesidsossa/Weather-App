import XCTest
@testable import WeatherApp

class WeatherDetailsInteractorTests: XCTestCase {
    var interactor: WeatherDetailsInteractor!
    var mockRepository: MockWeatherRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockWeatherRepository()
        interactor = WeatherDetailsInteractor(repository: mockRepository)
    }

    func testFetchWeatherDetails_CallsRepository() {
        // Arrange: Creamos datos ficticios para evitar el error "No data"
        let mockDetails = WeatherDetails(
            location: LocationInfo(name: "New York", country: "USA"),
            current: CurrentWeather(temp_c: 25.0, condition: WeatherCondition(text: "Sunny", icon: "//cdn.weatherapi.com/icon.png")),
            forecast: ForecastInfo(forecastday: [])
        )

        mockRepository.mockWeatherDetails = mockDetails 

        // Act
        interactor.fetchWeatherDetails(location: "New York") { result in
            switch result {
            case .success(let details):
                XCTAssertEqual(details.location.name, "New York", "La ubicación devuelta debería ser 'New York'")
            case .failure:
                XCTFail("No debería haber fallado la llamada al repositorio")
            }
        }

        // Assert
        XCTAssertTrue(mockRepository.fetchWeatherDetailsCalled, "El repositorio debería haber sido llamado")
        XCTAssertEqual(mockRepository.locationReceived, "New York", "El nombre de la ubicación enviada debería ser 'New York'")
    }


}
