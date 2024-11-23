//
//  VideoGalleryViewCell.swift
//  CameraModule
//
//  Created by Kathryn Verkhogliad on 22.11.2024.
//

import UIKit
import AVKit

class VideoGalleryViewCell: UICollectionViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var videoUrl: URL?
    
    func config(_ videoUrl: URL) {
        self.videoUrl = videoUrl
        
        let asset = AVAsset(url: videoUrl)
        
        imageView.image = generateThumbnail(for: asset)
        timeLabel.text = duration(of: asset)
    }
    
    func generateThumbnail(for asset: AVAsset) -> UIImage? {
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        let time = CMTime(seconds: 0, preferredTimescale: 600)
        do {
            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            print("Error generating thumbnail: \(error)")
            return nil
        }
    }
    
    func duration(of asset: AVAsset) -> String {
        let durationInSeconds = CMTimeGetSeconds(asset.duration)
        
        let hours = Int(durationInSeconds) / 3600
        let minutes = Int(durationInSeconds) / 60
        let seconds = Int(durationInSeconds) % 60
            
        return (String(format: "%02d:%02d:%02d", hours, minutes, seconds))
    }
}
