//
//  LibraryManager.swift
//  CameraModule
//
//  Created by Kathryn Verkhogliad on 23.11.2024.
//

import UIKit
import Photos

class LibraryManager {
    let delegate: UIViewController
    
    init(delegate: UIViewController) {
        self.delegate = delegate
    }
    
    func saveToLibrary(_ url: URL) async {
        guard await isPhotoLibraryReadWriteAccessGranted else {
            await delegate.showAlert(title: "Permission Denied", message: "Unable to access the photo library.")
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            let creationRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
            creationRequest?.creationDate = Date()
        }) { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    self?.delegate.showAlert(title: "Success", message: "Saved to gallery.")
                } else {
                    print(error?.localizedDescription ?? "")
                    self?.delegate.showAlert(title: "Error", message: "Failed to save to the gallery.")
                }
            }
        }
    }

    
    var isPhotoLibraryReadWriteAccessGranted: Bool {
        get async {
            let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)

            var isAuthorized = status == .authorized

            if status == .notDetermined {
                isAuthorized = await PHPhotoLibrary.requestAuthorization(for: .readWrite) == .authorized
            }
            
            return isAuthorized
        }
    }
}
