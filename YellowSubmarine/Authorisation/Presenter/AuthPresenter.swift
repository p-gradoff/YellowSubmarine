import Foundation
import UIKit

protocol AuthPresenterProtocol : AnyObject {
    func loadView(controller: ViewControllerProtocol, view: AuthViewProtocol)
}

final class AuthPresenter {
    private let authModel : AuthModelProtocol
    private let router : Router
    private weak var view : AuthViewProtocol?
    private weak var controller : ViewControllerProtocol?
    
    struct Dependencies {
        let model : AuthModelProtocol
        let router : Router
    }
    
    init(dependencies: Dependencies) {
        self.authModel = dependencies.model
        self.router = dependencies.router
    }
}

extension AuthPresenter {
    
    func onLogTouched() {
        
        guard let initialAuthUserData = self.view?.getAuthUserData() else { return }
        
        self.authModel.signIn(userData: initialAuthUserData) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let success):
                if success {
                    router.nextController()
                }

            case .failure(let failure):
                controller?.createAlert(errorMessage: failure.rawValue)
            }
        }
        
    }
    
    func onRegTouched() {
        self.router.prevController()
    }
    
    func setHandlers() {
        
        self.view?.goToRegHandler = { [weak self] in
            guard let self = self else { return }
            self.onRegTouched()
        }
        
        self.view?.goToProfileHandler = { [weak self] in
            guard let self = self else { return }
            self.onLogTouched()
        }
    }
}

extension AuthPresenter : AuthPresenterProtocol {
    func loadView(controller: ViewControllerProtocol, view: AuthViewProtocol) {
        self.controller = controller
        self.view = view
        
        self.setHandlers()
    }
}