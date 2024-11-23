//
//  CameraViewController+Capturing.swift
//  CameraModule
//
//  Created by Kathryn Verkhogliad on 22.11.2024.
//

import UIKit
import AVFoundation

extension CameraViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Task {
            await setupCaptureSession()
            
            DispatchQueue.main.async {
                let cameraPreview = self.cameraPreview as! PreviewView
                cameraPreview.videoPreviewLayer.session = self.captureSession
            }
            
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.captureSession.startRunning()
                print("Started running")
            }
        }
    }

    func setupCaptureSession() async {
        guard await isAudioAuthorized,
              await isVideoAuthorized else {
          return
      }
        
        self.captureSession.beginConfiguration()
        
        addInputDevices()
        addOutputs()
        
        
        captureSession.commitConfiguration()
    }
    
    func addInputDevices() {
        if
            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
            captureSession.canAddInput(videoDeviceInput) {
            captureSession.addInput(videoDeviceInput)
        }
        if
            let audioDeviceInput = try? AVCaptureDeviceInput(device: audioDevice!),
            captureSession.canAddInput(audioDeviceInput) {
            captureSession.addInput(audioDeviceInput)
        }
    }
    
    func addOutputs() {
        guard captureSession.canAddOutput(photoOutput) else { return }
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput)
        
        guard captureSession.canAddOutput(videoOutput) else { return }
        captureSession.sessionPreset = .high
        captureSession.addOutput(videoOutput)
    }
    
    func capturePhoto() {
        let photoSettings: AVCapturePhotoSettings
        
        if self.photoOutput.availablePhotoCodecTypes.contains(.hevc) {
            photoSettings = AVCapturePhotoSettings(format:
                [AVVideoCodecKey: AVVideoCodecType.hevc])
        } else {
            photoSettings = AVCapturePhotoSettings()
        }
        
        photoSettings.flashMode = .on
        
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
}
