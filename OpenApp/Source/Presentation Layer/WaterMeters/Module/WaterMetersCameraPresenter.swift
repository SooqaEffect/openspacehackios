//
//  WaterMetersCameraPresenter.swift
//  OpenApp
//
//  Created by Вячеслав Яшунин on 24.10.2020.
//

import Foundation
import AVFoundation
import Vision
import UIKit.UIImage

final class WaterMetersCameraPresenter: NSObject, WaterMetersCameraPresenterProtocol {
    
    weak var output: WaterMetersCameraPresenterOutput?
    var interactor: WaterMetersCameraInteractorInput?
    
    private lazy var captureQueue = DispatchQueue(label: "captureQueue")
    private lazy var photoOutput = AVCapturePhotoOutput()
    
    init(output: WaterMetersCameraPresenterOutput) {
        self.output = output
    }
    
    var visionRequests = [VNRequest]()
}

//MARK: - Presenter input methods (VIEW -> PRESENTER)
extension WaterMetersCameraPresenter: WaterMetersCameraPresenterInput {
    func onImagePicked(_ imageData: Data) {
        self.output?.onImageProccessed()
        self.interactor?.uploadImage(with: imageData)
    }
    
    
    func setupCamera(with previewLayer: inout AVCaptureVideoPreviewLayer?, session: AVCaptureSession) {
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        self.output?.showCamera(with: previewLayer!)
        self.setVisionClassification()
        self.setSession(session)
    }
    
    func capture() {
        captureQueue.async {
            self.photoOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        }
    }
}


//MARK: - Buffer delegate methods
extension WaterMetersCameraPresenter: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        var requestOptions: [VNImageOption: Any] = [:]
        if let cameraIntrinsicData = CMGetAttachment(sampleBuffer, key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, attachmentModeOut: nil) {
            requestOptions = [.cameraIntrinsics: cameraIntrinsicData]
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: CGImagePropertyOrientation(rawValue: 1)!, options: requestOptions)
        do {
            try imageRequestHandler.perform(visionRequests)
        } catch {
            print(error)
        }
    }
}
//MARK: - Capture photo delegate
extension WaterMetersCameraPresenter: AVCapturePhotoCaptureDelegate {
        func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
            self.output?.captureFlash()
        }
    
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            if let error = error {
                self.output?.showError(error.localizedDescription)
            } else {
                self.output?.onImageProccessed()
                self.interactor?.uploadImage(with: photo.fileDataRepresentation()!)
            }
        }
    
}

//MARK: - Private methods
private extension WaterMetersCameraPresenter {
    //MARK: - CoreML
    func setVisionClassification() {
        let conf = MLModelConfiguration()
        guard let visionModel = try? VNCoreMLModel(for: Counters.init(configuration: conf).model) else {
            fatalError("Could not load model")
        }
        
        let classificationRequest = VNCoreMLRequest(model: visionModel, completionHandler: handleClassifications)
        classificationRequest.imageCropAndScaleOption = .centerCrop
        visionRequests = [classificationRequest]
    }
    
    
     func handleClassifications(request: VNRequest, error: Error?) {
        
        guard let result = request.results as? [VNRecognizedObjectObservation] else { return }
        
        result.forEach {
            if let _ = $0.labels.filter({ $0.identifier == "Water meter" }).first {
                self.output?.showWhiteBoundingBox()
            }
            
            
            
            if let _ = $0.labels.first(where: { $0.identifier == "Counter" }) {
                let detections = result
                checkPosition(detections: detections)
            }
     
        }
    }
    
    func checkPosition(detections: [VNRecognizedObjectObservation]) {
        for detection in detections {
            self.output?.checkPosition(boundingBoxY: detection.boundingBox.minY, boundingBoxHeigh: detection.boundingBox.height)
        }
    }
}



private extension WaterMetersCameraPresenter {
    
    
    func setSession(_ session: AVCaptureSession) {
        guard let camera = AVCaptureDevice.default(for: .video) else {
            return
        }
        
        do {
            let cameraInput = try AVCaptureDeviceInput(device: camera)
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.setSampleBufferDelegate(self, queue: captureQueue)
            videoOutput.alwaysDiscardsLateVideoFrames = true
            videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
            
            session.sessionPreset = .high
            session.addInput(cameraInput)
            session.addOutput(videoOutput)
            session.addOutput(photoOutput)
            
            let connection = videoOutput.connection(with: .video)
            connection?.videoOrientation = .portrait
            session.startRunning()
        }
        catch {
            self.output?.showError(error.localizedDescription)
        }

    }
}
