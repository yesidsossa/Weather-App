import XCTest
@testable import WeatherApp

class SearchInteractorTests: XCTestCase {
    var interactor: SearchInteractor!
    var mockWeatherRepository: MockWeatherRepository!
    var mockFavoritesRepository: MockFavoritesRepository!

    override func setUp() {
        super.setUp()
        mockWeatherRepository = MockWeatherRepository()
        mockFavoritesRepository = MockFavoritesRepository()
        interactor = SearchInteractor(repository: mockWeatherRepository, favoritesRepository: mockFavoritesRepository)
    }

    func testFetchLocations_Success() {
        let expectedLocations = [Location(name: "New York", country: "USA")]
        mockWeatherRepository.mockLocations = expectedLocations

        let expectation = self.expectation(description: "fetchLocations completion called")

        interactor.fetchLocations(query: "New") { result in
            switch result {
            case .success(let locations):
                XCTAssertEqual(locations, expectedLocations)
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testAddFavorite_ShouldSaveToFavoritesRepository() {
        let location = Location(name: "Paris", country: "France")

        let expectation = self.expectation(description: "Agregar favorito")
        
        interactor.addFavorite(location) { result in
            switch result {
            case .success:
                XCTAssertTrue(self.mockFavoritesRepository.addFavoriteCalled, "El repositorio de favoritos debería haber guardado la ubicación")
            case .failure:
                XCTFail("No debería haber fallado al agregar un favorito")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testRemoveFavorite_ShouldDeleteFromFavoritesRepository() {
        let favorite = FavoriteLocation(name: "Paris", country: "France", temp: nil, icon: nil)

        let expectation = self.expectation(description: "Eliminar favorito")

        interactor.removeFavorite(favorite) { result in
            switch result {
            case .success:
                XCTAssertTrue(self.mockFavoritesRepository.removeFavoriteCalled, "El repositorio de favoritos debería haber eliminado la ubicación")
            case .failure:
                XCTFail("No debería haber fallado al eliminar un favorito")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testAddFavorite_WhenRepositoryFails_ShouldReturnError() {
        let location = Location(name: "Paris", country: "France")
        mockFavoritesRepository.shouldReturnError = true

        let expectation = self.expectation(description: "Agregar favorito falla")

        interactor.addFavorite(location) { result in
            switch result {
            case .success:
                XCTFail("No debería haber guardado un favorito cuando hay error")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Error al agregar favorito")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testRemoveFavorite_WhenRepositoryFails_ShouldReturnError() {
        let favorite = FavoriteLocation(name: "Paris", country: "France", temp: nil, icon: nil)
        mockFavoritesRepository.shouldReturnError = true

        let expectation = self.expectation(description: "Eliminar favorito falla")

        interactor.removeFavorite(favorite) { result in
            switch result {
            case .success:
                XCTFail("No debería haber eliminado un favorito cuando hay error")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Error al eliminar favorito")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }


}
