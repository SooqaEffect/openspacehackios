//
//  WaterMetersAssembly.swift
//  OpenApp
//
//  Created by Вячеслав Яшунин on 24.10.2020.
//

import Foundation


final class WaterMetersCameraAssembly {
    func assembly(with output: WaterMetersCameraPresenterOutput, networkManager: WaterMetersNetworkManager) {
        let presenter = WaterMetersCameraPresenter(output: output)
        let interactor = WaterMetersCameraInteractor(networkManager: networkManager)
        presenter.interactor = interactor
        output.presenter = presenter
    }
}
