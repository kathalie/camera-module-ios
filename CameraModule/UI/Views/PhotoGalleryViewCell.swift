//
//  GaleryCellView.swift
//  CameraModule
//
//  Created by Kathryn Verkhogliad on 22.11.2024.
//

import UIKit

class PhotoGalleryViewCell: UICollectionViewCell {
    private var imageUrl: URL?
    private var showAlert: ((@escaping () -> Void) -> Void)?
    @IBOutlet weak var imageView: UIImageView!
    
    func config(url: URL, showAlert: @escaping ((@escaping () -> Void) -> Void)) {
        self.imageUrl = url
        self.showAlert = showAlert
        
        setupImageView()
        setupGestureRecogniser()
    }
    
    private func setupImageView() {
        guard let imageUrl else { return }
        
        guard let image = UIImage(contentsOfFile: imageUrl.path) else {
            fatalError()
        }
        
        imageView.image = image
    }
    
    private func setupGestureRecogniser() {
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(deleteImage))
        
        self.addGestureRecognizer(longPressGR)
    }
    
    @objc
    private func deleteImage() {
        guard let imageUrl,
              let showAlert
        else { return }
        
        AnimationProvider.shared.zoomInAnimation(view: self) {
            showAlert {
                StorageManager.shared.removeFile(at: imageUrl)

                NotificationCenter.default.post(name: GalleryViewController.NotificationName.needGalleryUpdate, object: nil)
            }
        }
    }
}
