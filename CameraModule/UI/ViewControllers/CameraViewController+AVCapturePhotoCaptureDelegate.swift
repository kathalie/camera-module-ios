//
//  PhotoCaptureProcessor.swift
//  CameraModule
//
//  Created by Kathryn Verkhogliad on 22.11.2024.
//

import UIKit
import AVFoundation

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("didFinidhProcessingPhoto")
        guard error == nil else {
            showAlert(title: "Failed to capture a photo", message: "Please, try again.")
            print("Error capturing photo: \(error!.localizedDescription)")
            
            return
        }
        
        guard let photoData = photo.fileDataRepresentation() else {
            showAlert(title: "Failed to save a photo", message: "Something went wrong with a photo.")
            print("Failed to get photo data representation")
            return
        }
        
        do {
            try StorageManager.shared.saveImage(photoData)
        } catch {
            showAlert(title: "Failed to save a photo", message: "Something went wrong while writing to the file system.")
            print("Error saving photo: \(error.localizedDescription)")
        }
        
        NotificationCenter.default.post(name: GalleryViewController.NotificationName.needGalleryUpdate, object: nil)
    }
}
