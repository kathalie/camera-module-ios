//
//  PhotoPreviewViewController.swift
//  CameraModule
//
//  Created by Kathryn Verkhogliad on 23.11.2024.
//

import UIKit
import Photos

class PhotoPreviewViewController: UIViewController {
    var imageUrl: URL?
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func saveToGallery(_ sender: Any) {
        guard let imageUrl else {
            return
        }
        
        Task {
            let success = await LibraryManager().saveToLibrary(imageUrl, content: .photo)
            
            switch success {
            case true:
                showAlert(title: "Done", message: "File was saved to the library.")
            case false:
                showAlert(title: "Error", message: "Failed to save the file to the library.")
            default:
                showAlert(title: "No permission to access the photo library", message: "Please, enable access to the library to save the file.", shouldShowGoToSettingsButton: true)
            }
         }
    }
    
    func config(imageUrl: URL) {
        self.imageUrl = imageUrl
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let imageUrl else {return}
        
        let image = UIImage(contentsOfFile: imageUrl.path)

        
        imageView.image = image
    }
}
