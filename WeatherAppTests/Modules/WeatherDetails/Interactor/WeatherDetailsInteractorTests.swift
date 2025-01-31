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
        // Act
        interactor.fetchWeatherDetails(location: "New York") { _ in }

        // Assert
        XCTAssertTrue(mockRepository.fetchWeatherDetailsCalled, "El repositorio debería haber sido llamado")
        XCTAssertEqual(mockRepository.locationReceived, "New York", "El nombre de la ubicación enviada debería ser 'New York'")
    }
}
