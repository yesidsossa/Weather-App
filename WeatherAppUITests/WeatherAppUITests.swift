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

        firstCell.tap()

        let detailView = app.staticTexts["currentTempLabel"]
        
        XCTAssertTrue(detailView.waitForExistence(timeout: 10), "Debería navegar a la pantalla de detalles")
    }
    
    func testAddToFavorites_ShowsInFavoritesList() {
        let searchField = app.textFields["Buscar ubicación..."]
        XCTAssertTrue(searchField.waitForExistence(timeout: 8), "El campo de búsqueda debería existir")

        searchField.tap()
        searchField.typeText("Berlin")

        closeKeyboardIfNeeded()

        let firstCell = app.tables["searchResultsTableView"].cells.element(boundBy: 0)
        let exists = firstCell.waitForExistence(timeout: 10)
        XCTAssertTrue(exists, "Debería haber resultados en la búsqueda")

        let favoriteButton = firstCell.buttons["favoriteButton"]
        XCTAssertTrue(favoriteButton.waitForExistence(timeout: 2), "El botón de favoritos debería existir en la celda")
        favoriteButton.tap()

        firstCell.tap()

        let backButton = app.buttons["backButton"]
        XCTAssertTrue(backButton.exists, "El botón de retroceso debería existir")
        backButton.tap()

        clearSearchField(searchField)

        let favoritesTable = app.tables["favoritesTableView"]
        XCTAssertTrue(favoritesTable.waitForExistence(timeout: 10), "La tabla de favoritos debería aparecer")

        let favoriteCell = favoritesTable.cells.element(boundBy: 0)
        XCTAssertTrue(favoriteCell.waitForExistence(timeout: 5), "La ubicación debería aparecer en la lista de favoritos")
    }

    private func closeKeyboardIfNeeded() {
        let returnKey = app.keyboards.keys["Return"]
        if returnKey.exists {
            returnKey.tap()
        } else {
            app.tap()
        }
    }

    private func clearSearchField(_ searchField: XCUIElement) {
        let clearButton = searchField.buttons["Clear text"]
        if clearButton.exists {
            clearButton.tap()
        } else {
            searchField.tap()
            searchField.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: 15))
        }
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

        let expectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "count < %d", initialCellCount),
            object: favoritesTable.cells
        )
        
        let result = XCTWaiter().wait(for: [expectation], timeout: 5)
        XCTAssertEqual(result, .completed, "El favorito debería haber sido eliminado de la tabla")
    }


}
