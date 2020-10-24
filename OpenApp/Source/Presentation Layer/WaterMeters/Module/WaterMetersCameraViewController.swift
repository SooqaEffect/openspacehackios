//
//  WaterMetersCameraViewController.swift
//  OpenApp
//
//  Created by Вячеслав Яшунин on 23.10.2020.
//

import UIKit
import AVFoundation
import Vision
import Photos

final class WaterMetersCameraViewController: UIViewController {
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var boundingBoxImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var autoPhotoSwitcher: UISwitch!
    
    var presenter: WaterMetersCameraPresenterInput?
    
    let session = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var isCounterFinded = false
    var isCaptured = false
    var countFined = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.boundingBoxImageView.alpha = 0
        self.presenter?.setupCamera(with: &previewLayer, session: session)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = UIScreen.main.bounds
        previewLayer?.videoGravity = .resizeAspectFill
        
    }
    
    //MARK: - private methods
    private func fillWhite() {
        guard !isCounterFinded else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            guard !self.isCounterFinded else { return }
            UIView.animate(withDuration: 0.7) {
                self.boundingBoxImageView.image = self.boundingBoxImageView.image!.withRenderingMode(.alwaysTemplate)
                self.boundingBoxImageView.tintColor = .white
                if !self.countFined.isEmpty {
                    self.countFined.removeLast()
                }
            }
        }
    }
    
    private func fillBlue() {
        guard self.isCounterFinded else { return }
        UIView.animate(withDuration: 0.7) {
            self.boundingBoxImageView.image = self.boundingBoxImageView.image!.withRenderingMode(.alwaysTemplate)
            self.boundingBoxImageView.tintColor = UIColor(hex: "#02BAE8")
            
            if self.countFined.count > 15 {
                self.capturePhoto()
            } else {
                self.countFined.append(true)
            }
        }
    }
    
    //MARK: - objc methods
    @IBAction func capturePhoto() {
        guard self.autoPhotoSwitcher.isOn else { return }
        guard !isCaptured else { return }
        presenter?.capture()
        isCaptured = true
    }
    
    @IBAction func onButtonPhotoLibraryClick() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
}

//MARK: - Presenter output methods (PRESENTER -> VIEW)
extension WaterMetersCameraViewController: WaterMetersCameraPresenterOutput {
    
    func checkPosition(boundingBoxY: CGFloat, boundingBoxHeigh: CGFloat) {
        DispatchQueue.main.async {
            
            let boundY = (1-boundingBoxY-boundingBoxHeigh)*self.view.frame.height
            print("Boudning Y", boundY)
            print("Image Y", self.boundingBoxImageView.frame.midY)
            
            let r = self.boundingBoxImageView.frame.midY - boundY
            print(r)
            if r < 150 && r > 0 {
                self.fillBlue()
                self.isCounterFinded = true
            } else {
                self.fillWhite()
                self.isCounterFinded = false
            }
            
        }
    }
    
    func showWhiteBoundingBox() {
        DispatchQueue.main.async {
            guard self.boundingBoxImageView.alpha == 0 else { return }
            UIView.animate(withDuration: 0.7) {
                self.boundingBoxImageView.alpha = 1
            }
        }
    }
    
    func showBlueBoundingBox() {
        DispatchQueue.main.async {
            guard self.boundingBoxImageView.alpha == 1 else { return }
            UIView.animate(withDuration: 0.7) {
                self.boundingBoxImageView.image = UIImage(named: "bounding-box-blue")
            }
        }
    }
    
    func hideBoundingBox() {
        
    }
    
    func showCamera(with previewLayer: AVCaptureVideoPreviewLayer) {
        cameraView.layer.addSublayer(previewLayer)
    }
    
    func onImageProccessed() {
        self.session.stopRunning()
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    func showError(_ errorString: String) {
        let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func captureFlash() {
        self.previewLayer?.opacity = 0
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        animation.fromValue = 0
        animation.toValue = 1
        animation.autoreverses = false
        animation.duration = 0.25
        self.previewLayer?.opacity = 1
        
        self.previewLayer?.add(animation, forKey: "opacityAnimation")
    }
}

extension WaterMetersCameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage, let imageData = image.pngData() else { return }
        self.presenter?.onImagePicked(imageData)
        picker.dismiss(animated: true, completion: nil)
    }
}
