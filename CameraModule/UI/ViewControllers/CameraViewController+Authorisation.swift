//
//  CameraViewController+Authorisation.swift
//  CameraModule
//
//  Created by Kathryn Verkhogliad on 22.11.2024.
//

import AVFoundation

extension CameraViewController {
    var isVideoAuthorized: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            
            var isAuthorized = status == .authorized
            
            if status == .notDetermined {
                isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
            }
            
            isAuthorized ? print("Video authorized") : print("Video FORBIDDEN")
            
            return isAuthorized
        }
    }
    
    var isAudioAuthorized: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .audio)
            
            var isAuthorized = status == .authorized
            
            if status == .notDetermined {
                isAuthorized = await AVCaptureDevice.requestAccess(for: .audio)
            }
            
            isAuthorized ? print("Audio authorized") : print("Audio FORBIDDEN")
            
            return isAuthorized
        }
    }
}
