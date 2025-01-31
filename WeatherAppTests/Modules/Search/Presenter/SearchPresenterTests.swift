import XCTest
@testable import WeatherApp

class SearchPresenterTests: XCTestCase {
    var presenter: SearchPresenter!
    var mockInteractor: MockSearchInteractor!
    var mockView: MockSearchView!
    var mockRouter: MockSearchRouter!

    override func setUp() {
        super.setUp()
        mockInteractor = MockSearchInteractor()
        mockView = MockSearchView()
        mockRouter = MockSearchRouter()
        presenter = SearchPresenter(interactor: mockInteractor, view: mockView, router: mockRouter)
    }

    func testSearchLocation_CallsInteractor() {
        // Act
        presenter.searchLocation(query: "New York")

        // Assert
        XCTAssertTrue(mockInteractor.fetchLocationsCalled, "El interactor debería haber sido llamado")
        XCTAssertEqual(mockInteractor.queryReceived, "New York", "El query enviado debería ser 'New York'")
    }

    func testSearchLocation_ClearsResults_WhenQueryIsEmpty() {
        // Act
        presenter.searchLocation(query: "")

        // Assert
        XCTAssertTrue(mockView.locationsReceived.isEmpty, "La vista debería mostrar una lista vacía cuando el query está vacío")
    }

    func testDidSelectLocation_CallsRouter() {
        // Arrange
        let location = Location(name: "New York", country: "USA")

        // Act
        presenter.didSelectLocation(location: location)

        // Assert
        XCTAssertTrue(mockRouter.navigateToWeatherDetailsCalled, "El router debería haber sido llamado")
        XCTAssertEqual(mockRouter.locationReceived?.name, "New York", "La ubicación enviada debería ser 'New York'")
    }
}
