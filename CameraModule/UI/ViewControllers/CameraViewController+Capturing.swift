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
            
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.captureSession.commitConfiguration()
                self?.captureSession.startRunning()
                print("Started running")
                
                DispatchQueue.main.async { [weak self] in
                    self?.enableUI()
                }
            }
        }
    }
    
    func enableUI() {
        captureButton.isHidden = false
        changeCameraPositionButton.isHidden = false
        capturingModesSegmentedView.isHidden = false
        cameraPreview.isHidden = false
    }
    
    func makeVideoDevice(for position: AVCaptureDevice.Position) -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInDualCamera,
                                                for: .video, position: position) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                       for: .video, position: position) {
            return device
        } else {
            fatalError("Missing expected back camera device.")
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
        let videoDevice = makeVideoDevice(for: .back)
        let audioDevice = AVCaptureDevice.default(for: .audio)
        if
            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
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
        
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    func captureVideo() {
        guard captureSession.isRunning,
              !videoOutput.isRecording
        else { return }
        
        let path = StorageManager.shared.getDocumentsDirectory()
        
        let fileUrl = path.appendingPathComponent("MOV\(Date.now).mp4")
        
        videoOutput.startRecording(to: fileUrl, recordingDelegate: self)
    }
    
    func stopVideo() {
        guard captureSession.isRunning,
              videoOutput.isRecording
        else { return }
        
        videoOutput.stopRecording()
    }
}
