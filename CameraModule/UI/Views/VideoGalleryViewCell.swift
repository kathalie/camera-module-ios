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
    
    private var videoUrl: URL?
    private var showAlert: ((@escaping () -> Void) -> Void)?
    
    func config(url: URL, showAlert: @escaping ((@escaping () -> Void) -> Void)) {
        self.videoUrl = url
        self.showAlert = showAlert
        
        setupImageView()
        setupGestureRecogniser()
    }
    
    private func setupImageView() {
        guard let videoUrl else { return }
        
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
    
    private func setupGestureRecogniser() {
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(deleteVideo))
        
        self.addGestureRecognizer(longPressGR)
    }
    
    @objc
    private func deleteVideo() {
        guard let videoUrl,
              let showAlert
        else { return }
        
        AnimationProvider.shared.zoomInAnimation(view: self) {
            showAlert {
                StorageManager.shared.removeFile(at: videoUrl)

                NotificationCenter.default.post(name: GalleryViewController.NotificationName.needGalleryUpdate, object: nil)
            }
        }
    }
}
