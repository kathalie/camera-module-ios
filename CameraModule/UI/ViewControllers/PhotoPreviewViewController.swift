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
            await LibraryManager(delegate: self).saveToLibrary(imageUrl, content: .photo)
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
