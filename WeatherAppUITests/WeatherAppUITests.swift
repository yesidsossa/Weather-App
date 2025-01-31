import XCTest

class WeatherAppUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }

    func testSplashScreen_NavigatesToSearch() {
        let animation = app.otherElements["splashAnimation"]
        XCTAssertTrue(animation.waitForExistence(timeout: 3), "La animación de Splash debería mostrarse")
        
        let searchField = app.textFields["Buscar ubicación..."]
        XCTAssertTrue(searchField.waitForExistence(timeout: 8), "La pantalla de búsqueda debería aparecer después del Splash")
    }

    func testSelectLocation_NavigatesToDetail() {
        let searchField = app.textFields["Buscar ubicación..."]
        XCTAssertTrue(searchField.waitForExistence(timeout: 8), "El campo de búsqueda debería existir")

        searchField.tap()
        searchField.typeText("Paris")

        let firstCell = app.tables["searchResultsTableView"].cells.element(boundBy: 0)

        XCTAssertTrue(firstCell.waitForExistence(timeout: 8), "Debería haber al menos un resultado en la búsqueda")

        app.tap()
        firstCell.tap()

        let detailView = app.staticTexts["currentTempLabel"]
        
        XCTAssertTrue(detailView.waitForExistence(timeout: 10), "Debería navegar a la pantalla de detalles")
    }


    func testAddToFavorites_ShowsInFavoritesList() {
        let searchField = app.textFields["Buscar ubicación..."]
        XCTAssertTrue(searchField.waitForExistence(timeout: 8), "El campo de búsqueda debería existir")

        searchField.tap()
        searchField.typeText("Berlin")

        let firstCell = app.tables["searchResultsTableView"].cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5), "Debería haber resultados en la búsqueda")

        firstCell.tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()

        let favoritesTable = app.tables["favoritesTableView"]
        XCTAssertTrue(favoritesTable.exists, "La tabla de favoritos debería existir")
        
        let favoriteCell = favoritesTable.cells.element(boundBy: 0)
        XCTAssertTrue(favoriteCell.waitForExistence(timeout: 5), "La ubicación debería aparecer en la lista de favoritos")
    }

    func testRemoveFromFavorites_HidesFromList() {
        let favoritesTable = app.tables["favoritesTableView"]
        
        XCTAssertTrue(favoritesTable.waitForExistence(timeout: 8), "La tabla de favoritos debería existir")

        let initialCellCount = favoritesTable.cells.count
        let favoriteCell = favoritesTable.cells.element(boundBy: 0)

        XCTAssertTrue(favoriteCell.exists, "Debería haber al menos un favorito para eliminar")

        let removeButton = favoriteCell.buttons["Eliminar"]
        XCTAssertTrue(removeButton.exists, "El botón de eliminar debería estar presente")

        removeButton.tap()

        sleep(2)

        let newCellCount = favoritesTable.cells.count

        XCTAssertTrue(newCellCount < initialCellCount, "El favorito debería haber sido eliminado de la tabla")
    }

}
