//
//  CameraViewController+Capturing.swift
//  CameraModule
//
//  Created by Kathryn Verkhogliad on 22.11.2024.
//

import UIKit
import AVFoundation

extension CameraViewController {
    var isAuthorized: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            
            var isAuthorized = status == .authorized
            
            if status == .notDetermined {
                isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
            }
            
            return isAuthorized
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Task {
            await setUpCaptureSession()

            DispatchQueue.main.async {
                let cameraPreview = self.cameraPreview as! PreviewView
                cameraPreview.videoPreviewLayer.session = self.captureSession
            }
            
            DispatchQueue.global(qos: .background).async {
                self.captureSession.startRunning()
            }
        }
    }


    func setUpCaptureSession() async {
        guard await isAuthorized else { return }
        
        self.captureSession.beginConfiguration()
        
        addInputDevices()
        addOutputDevices()
        
        captureSession.commitConfiguration()
    }
    
    func addInputDevices() {
        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                  for: .video, position: .unspecified)
        let audioDevice = AVCaptureDevice.default(for: .audio)
        
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
    
    func addOutputDevices() {
        let photoOutput = AVCapturePhotoOutput()
        guard captureSession.canAddOutput(photoOutput) else { return }
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput)
        
        let videoOutput = AVCaptureMovieFileOutput()
        guard captureSession.canAddOutput(videoOutput) else { return }
        captureSession.sessionPreset = .high
        captureSession.addOutput(videoOutput)
    }
}
