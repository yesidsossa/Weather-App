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

        interactor.addFavorite(location)

        XCTAssertTrue(mockFavoritesRepository.addFavoriteCalled, "El repositorio de favoritos debería haber guardado la ubicación")
    }

    func testRemoveFavorite_ShouldDeleteFromFavoritesRepository() {
        let favorite = FavoriteLocation(name: "Paris", country: "France", temp: nil, icon: nil)

        interactor.removeFavorite(favorite)

        XCTAssertTrue(mockFavoritesRepository.removeFavoriteCalled, "El repositorio de favoritos debería haber eliminado la ubicación")
    }
}
