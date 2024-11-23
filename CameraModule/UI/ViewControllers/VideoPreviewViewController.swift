//
//  VideoPreviewViewController.swift
//  CameraModule
//
//  Created by Kathryn Verkhogliad on 23.11.2024.
//

import Foundation
import AVKit

class VideoPreviewViewController: AVPlayerViewController {
    var videoUrls: [URL]?
    var currentIndex: Int = 0
    
    @IBAction func saveToGallery(_ sender: Any) {
        guard let videoUrls else {
            return
        }
        
        Task {
            await LibraryManager(delegate: self).saveToLibrary(videoUrls[currentIndex], content: .video)
         }
    }
    
    func config(videoUrls: [URL], currentIndex: Int) {
        self.videoUrls = videoUrls
        self.currentIndex = currentIndex
        
        assert(currentIndex < videoUrls.count)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePlayer()
    }
    
    private func configurePlayer() {
        guard let videoUrls else {
            return
        }
        
        let currentUrl = videoUrls[currentIndex]
        
        let player = AVPlayer(url: currentUrl)
        self.player = player
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playNextVideo),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem
        )
    }
    
    @objc private func playNextVideo() {
        guard let videoUrls else {
            return
        }
        
        currentIndex += 1
        if currentIndex < videoUrls.count {
            configurePlayer()
            self.player?.play()
        } else {
            showAlert(title: "Finished", message: "You have reached the end of the playlist.")
        }
    }
}
    
