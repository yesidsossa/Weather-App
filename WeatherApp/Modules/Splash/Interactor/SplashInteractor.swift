import Foundation

protocol SplashInteractorProtocol {
    func loadInitialData(completion: @escaping () -> Void)
}

class SplashInteractor: SplashInteractorProtocol {
    func loadInitialData(completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion()
        }
    }
}
