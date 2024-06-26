import Foundation
import UIKit

protocol PersonPresenterProtocol : AnyObject {
    func loadView(controller: PersonViewControllerProtocol, view: PersonViewProtocol)
}

final class PersonPresenter {
    let personModel : PersonModelProtocol
    let router : Router
    weak var view : PersonViewProtocol?
    weak var controller : PersonViewControllerProtocol?
    
    struct Dependencies {
        let model : PersonModelProtocol
        let router : Router
    }
    
    init(dependencies: Dependencies) {
        self.personModel = dependencies.model
        self.router = dependencies.router
    }
}

private extension PersonPresenter {
    
    private func onSendDataTouched(_ image: UIImage) {
        
        guard let imgData = image.jpegData(compressionQuality: 0.1) else { print("compression went wrong"); return}
        personModel.uploadImage(imgData: imgData)
        
        self.view?.getPersonData { result in
            switch result {
            case .success(let isAllowed):
                if isAllowed { 
                    personModel.uploadPersonalUserData()
                    router.nextController()
                }
            case .failure(let err):
                controller?.createAlert(message: err.rawValue, buttonText: "Cancel", isClosingAction: false)
            }
        }
    }
    
    private func onImagePickerTouched() {
        guard let view = self.view else { print("no view"); return }
        self.controller?.presentPickerController(view.imagePicker)
    }
    
    private func setHandlers() {
        self.view?.sendData = { [weak self] image in
            guard let self = self else { return }
            self.onSendDataTouched(image)
        }
        
        self.view?.chooseProfilePicture = { [weak self] in
            guard let self = self else { return }
            self.onImagePickerTouched()
        }
    }
}

extension PersonPresenter : PersonPresenterProtocol {
    func loadView(controller: PersonViewControllerProtocol, view: PersonViewProtocol) {
        self.controller = controller
        self.view = view
        
        self.setHandlers()
    }
}
