//
//  WaterMetersCameraInteractorProtocols.swift
//  OpenApp
//
//  Created by Вячеслав Яшунин on 24.10.2020.
//

import Foundation

protocol WaterMetersCameraInteractorProtocol {
    var networkManager: WaterMetersNetworkManager { get }
    init(networkManager: WaterMetersNetworkManager)
}

protocol WaterMetersCameraInteractorInput {
    func uploadImage(with imageData: Data)
}

protocol WaterMetersCameraInteractorOutput {
    
}
