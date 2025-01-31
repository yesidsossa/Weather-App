import XCTest
@testable import WeatherApp

class SearchInteractorTests: XCTestCase {
    var interactor: SearchInteractor!
    var mockRepository: MockWeatherRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockWeatherRepository()
        interactor = SearchInteractor(repository: mockRepository)
    }

    func testFetchLocations_Success() {
        // Arrange
        let expectedLocations = [Location(name: "New York", country: "USA")]
        mockRepository.mockLocations = expectedLocations

        let expectation = self.expectation(description: "fetchLocations completion called")

        // Act
        interactor.fetchLocations(query: "New") { result in
            // Assert
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

    func testFetchLocations_Failure() {
        // Arrange
        mockRepository.shouldReturnError = true

        let expectation = self.expectation(description: "fetchLocations completion called")

        // Act
        interactor.fetchLocations(query: "New") { result in
            // Assert
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Error simulado")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
}
