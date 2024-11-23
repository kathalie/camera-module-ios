//
//  GaleryCellView.swift
//  CameraModule
//
//  Created by Kathryn Verkhogliad on 22.11.2024.
//

import UIKit

class PhotoGalleryViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func loadImage(from url: URL) {
        
        guard let image = UIImage(contentsOfFile: url.path) else {
            fatalError()
        }
        
        imageView.image = image
    }
}
