//
//  LibraryManager.swift
//  CameraModule
//
//  Created by Kathryn Verkhogliad on 23.11.2024.
//

import UIKit
import Photos

class LibraryManager {
    enum Content {
        case photo
        case video
    }
    
    func saveToLibrary(_ url: URL, content: Content) async -> Bool? {
        guard await isPhotoLibraryReadWriteAccessGranted else {            
            return nil
        }
        
        do {
            try await PHPhotoLibrary.shared().performChanges {
                print(url)
                switch content {
                case .photo:
                    let creationRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: url)
                    creationRequest?.creationDate = Date()
                case .video:
                    let creationRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
                    creationRequest?.creationDate = Date()
                }
            }
            
            return true
        } catch {
            print(error.localizedDescription)
            
            return false
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
