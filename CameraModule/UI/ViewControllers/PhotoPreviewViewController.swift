//
//  PhotoPreviewViewController.swift
//  CameraModule
//
//  Created by Kathryn Verkhogliad on 23.11.2024.
//

import UIKit
import Photos

class PhotoPreviewViewController: UIViewController {
    var image: UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func saveToGallery(_ sender: Any) {
        Task {
             guard await isPhotoLibraryReadWriteAccessGranted else {
                 showAlert(title: "Permission Denied", message: "Unable to access the photo library.")
                 return
             }
             
            guard let image = self.image else {
                 return
             }
             
             PHPhotoLibrary.shared().performChanges({
                 let creationRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                 creationRequest.creationDate = Date()
             }) { [weak self] success, error in
                 DispatchQueue.main.async {
                     if success {
                         self?.showAlert(title: "Success", message: "Photo saved to gallery.")
                     } else {
                         print(error?.localizedDescription ?? "")
                         self?.showAlert(title: "Error", message: "Feiled to save the photo.")
                     }
                 }
             }
         }
    }
    
    func config(imageUrl: URL) {
        guard let image = UIImage(contentsOfFile: imageUrl.path) else {
            fatalError()
        }
        
        self.image = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let image else {return}
        
        imageView.image = image
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
