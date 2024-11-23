//
//  CameraViewController+RecordingDelegate.swift
//  CameraModule
//
//  Created by Kathryn Verkhogliad on 23.11.2024.
//

import AVFoundation

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            showAlert(title: "Error", message: "Failed to record a video")
            print("Recording failed with error: \(error)")
        } else {
            print("Recording finished successfully at \(outputFileURL)")
        }
        
        NotificationCenter.default.post(name: GalleryViewController.NotificationName.needGalleryUpdate, object: nil)
    }
}
