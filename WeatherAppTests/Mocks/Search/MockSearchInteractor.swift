import Foundation
@testable import WeatherApp

class MockSearchInteractor: SearchInteractorProtocol {
    var fetchLocationsCalled = false
    var queryReceived: String?

    func fetchLocations(query: String, completion: @escaping (Result<[Location], Error>) -> Void) {
        fetchLocationsCalled = true
        queryReceived = query
        completion(.success([])) 
    }
}
