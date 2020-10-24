//
//  WaterMetersPresenterProtocols.swift
//  OpenApp
//
//  Created by Вячеслав Яшунин on 24.10.2020.
//

import AVFoundation

protocol WaterMetersCameraPresenterProtocol {
    var output: WaterMetersCameraPresenterOutput? { get }
    var interactor: WaterMetersCameraInteractorInput? { get set }
    init(output: WaterMetersCameraPresenterOutput)
}

protocol WaterMetersCameraPresenterInput {
    func setupCamera(with previewLayer: inout AVCaptureVideoPreviewLayer?, session: AVCaptureSession)
    func onImagePicked(_ imageData: Data)
    func capture()
}


protocol WaterMetersCameraPresenterOutput: class {
    var presenter: WaterMetersCameraPresenterInput? { get set }
    
    func showCamera(with previewLayer: AVCaptureVideoPreviewLayer)
    func onImageProccessed()
    func captureFlash()
    func showError(_ errorString: String)
    
    func showWhiteBoundingBox()
    func showBlueBoundingBox()
    func checkPosition(boundingBoxY: CGFloat, boundingBoxHeigh: CGFloat)
    func hideBoundingBox()
}
