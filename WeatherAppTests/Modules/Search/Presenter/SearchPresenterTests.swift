import XCTest
@testable import WeatherApp

class SearchPresenterTests: XCTestCase {
    var presenter: SearchPresenter!
    var mockInteractor: MockSearchInteractor!
    var mockView: MockSearchView!
    var mockCoordinator: MockCoordinator!

    override func setUp() {
        super.setUp()
        let navController = UINavigationController() 
        mockInteractor = MockSearchInteractor()
        mockView = MockSearchView()
        mockCoordinator = MockCoordinator(navigationController: navController) 
        presenter = SearchPresenter(interactor: mockInteractor, view: mockView, coordinator: mockCoordinator)
    }

    func testSearchLocation_CallsInteractor() {
        presenter.searchLocation(query: "New York")

        XCTAssertTrue(mockInteractor.fetchLocationsCalled, "El interactor debería haber sido llamado")
        XCTAssertEqual(mockInteractor.queryReceived, "New York", "El query enviado debería ser 'New York'")
    }

    func testSearchLocation_ClearsResults_WhenQueryIsEmpty() {
        presenter.searchLocation(query: "")

        XCTAssertTrue(mockView.locationsReceived.isEmpty, "La vista debería mostrar una lista vacía cuando el query está vacío")
    }

    func testDidSelectLocation_CallsCoordinator_AndAddsToFavorites() {
        let location = Location(name: "New York", country: "USA")

        presenter.didSelectLocation(location: location)

        XCTAssertTrue(mockInteractor.addFavoriteCalled, "El interactor debería haber agregado la ubicación a favoritos")
        XCTAssertTrue(mockCoordinator.didNavigateToWeatherDetails, "El coordinator debería haber manejado la navegación")
        XCTAssertEqual(mockCoordinator.receivedLocation?.name, "New York", "Se debería haber pasado correctamente la ubicación")
    }

    func testLoadFavorites_ShouldCallViewToDisplayFavorites() {
        mockInteractor.favorites = [FavoriteLocation(name: "Paris", country: "France", temp: 22.0, icon: nil)]

        presenter.loadFavorites()

        XCTAssertTrue(mockView.showFavoritesCalled, "La vista debería haber actualizado la lista de favoritos")
        XCTAssertEqual(mockView.favoritesReceived.count, 1, "Debería haber recibido 1 favorito")
    }

    func testRemoveFavorite_ShouldCallInteractor_AndReloadFavorites() {
        let favorite = FavoriteLocation(name: "Paris", country: "France", temp: 22.0, icon: nil)

        let expectation = self.expectation(description: "Espera que removeFavorite se complete")
        
        presenter.removeFavorite(location: favorite)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { 
            XCTAssertTrue(self.mockInteractor.removeFavoriteCalled, "El interactor debería haber eliminado el favorito")
            XCTAssertTrue(self.mockView.showFavoritesCalled, "La vista debería haber actualizado la lista de favoritos")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    
    func testSearchLocation_ShowsError_OnFailure() {
        // Arrange
        mockInteractor.shouldReturnError = true
        
        let expectation = self.expectation(description: "Esperando que showError sea llamado")

        mockView.showErrorCalled = false
        mockView.errorMessageReceived = nil

        // Act
        presenter.searchLocation(query: "Invalid Query")

        // Esperamos a que la ejecución del callback ocurra
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.mockView.showErrorCalled, "La vista debería haber llamado a showError")
            XCTAssertEqual(self.mockView.errorMessageReceived, "Error simulado", "El mensaje de error debe ser el esperado")
            expectation.fulfill()
        }

        // Esperamos un tiempo prudente para que la ejecución asincrónica ocurra
        wait(for: [expectation], timeout: 2)
    }

}
