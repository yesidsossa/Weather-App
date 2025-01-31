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
        presenter.searchLocation(query: "New York")

        XCTAssertTrue(mockInteractor.fetchLocationsCalled, "El interactor debería haber sido llamado")
        XCTAssertEqual(mockInteractor.queryReceived, "New York", "El query enviado debería ser 'New York'")
    }

    func testSearchLocation_ClearsResults_WhenQueryIsEmpty() {
        presenter.searchLocation(query: "")

        XCTAssertTrue(mockView.locationsReceived.isEmpty, "La vista debería mostrar una lista vacía cuando el query está vacío")
    }

    func testDidSelectLocation_CallsRouter_AndAddsToFavorites() {
        let location = Location(name: "New York", country: "USA")

        presenter.didSelectLocation(location: location)

        XCTAssertTrue(mockInteractor.addFavoriteCalled, "El interactor debería haber agregado la ubicación a favoritos")
        XCTAssertTrue(mockRouter.navigateToWeatherDetailsCalled, "El router debería haber navegado a detalles")
    }

    func testLoadFavorites_ShouldCallViewToDisplayFavorites() {
        mockInteractor.favorites = [FavoriteLocation(name: "Paris", country: "France", temp: 22.0, icon: nil)]

        presenter.loadFavorites()

        XCTAssertTrue(mockView.showFavoritesCalled, "La vista debería haber actualizado la lista de favoritos")
        XCTAssertEqual(mockView.favoritesReceived.count, 1, "Debería haber recibido 1 favorito")
    }

    func testRemoveFavorite_ShouldCallInteractor_AndReloadFavorites() {
        let favorite = FavoriteLocation(name: "Paris", country: "France", temp: 22.0, icon: nil)

        presenter.removeFavorite(location: favorite)

        XCTAssertTrue(mockInteractor.removeFavoriteCalled, "El interactor debería haber eliminado el favorito")
        XCTAssertTrue(mockView.showFavoritesCalled, "La vista debería haber actualizado la lista de favoritos")
    }
}
