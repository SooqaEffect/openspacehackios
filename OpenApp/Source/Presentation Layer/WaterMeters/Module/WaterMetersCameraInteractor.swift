//
//  WaterMetersCameraInteractor.swift
//  OpenApp
//
//  Created by Вячеслав Яшунин on 24.10.2020.
//

import Foundation

final class WaterMetersCameraInteractor: WaterMetersCameraInteractorProtocol {
    var networkManager: WaterMetersNetworkManager
    
    init(networkManager: WaterMetersNetworkManager) {
        self.networkManager = networkManager
    }
}

//MARK: - Input methods (PRESENTER -> INTERACTOR)
extension WaterMetersCameraInteractor: WaterMetersCameraInteractorInput {
    func uploadImage(with imageData: Data) {
        
        networkManager.uploadImage(imageData: imageData) { result in
            
            switch result {
            case .success(let response): print(response)
            case .fail(let error): print(error)
                
            }
        }
    }
}
