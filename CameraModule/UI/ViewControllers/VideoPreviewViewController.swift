//
//  VideoPreviewViewController.swift
//  CameraModule
//
//  Created by Kathryn Verkhogliad on 24.11.2024.
//

import Foundation
import AVKit

class VideoPreviewViewController: UIViewController {
    private var videoUrls: [URL]?
    private var currentIndex: Int = 0
    
    private var player: AVPlayer?
//    private var playerLayer: AVPlayerLayer?
    private var playerViewController: AVPlayerViewController?
    
    @IBOutlet weak var videoPlayerView: UIView!
    @IBOutlet private weak var previousButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    @IBAction private func saveToGallery(_ sender: Any) {
        guard let videoUrls else {
            return
        }
        
        Task {
            await LibraryManager(delegate: self).saveToLibrary(videoUrls[currentIndex], content: .video)
         }
    }
    
    @IBAction func goToPreviousVideo(_ sender: Any) {
        guard hasPreviousVideo else { return }
        
        currentIndex -= 1
        
        configurePlayer()
        setupControlButtons()
    }
    
    
    @IBAction func goToNextVideo(_ sender: Any) {
        guard hasNextVideo else { return }
        
        currentIndex += 1
        
        configurePlayer()
        setupControlButtons()
    }
    
    
    func config(videoUrls: [URL], currentIndex: Int) {
        assert(currentIndex < videoUrls.count)
        
        self.videoUrls = videoUrls
        self.currentIndex = currentIndex
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configurePlayer()
    }
    
    private func setupUI() {
        setupControlButtons()
        setupPreviewVC()
    }
    
    private var hasNextVideo: Bool {
        guard let videoUrls else {
            return false
        }
        
        return currentIndex < videoUrls.count - 1
    }
    
    private var hasPreviousVideo: Bool {
        return currentIndex > 0
    }
    
    private func setupControlButtons() {
        self.nextButton.isEnabled = hasNextVideo
        self.previousButton.isEnabled = hasPreviousVideo
    }
    
    private func setupPreviewVC() {
        playerViewController = AVPlayerViewController()
        
//        playerViewController?.view.removeFromSuperview()
//        playerViewController?.removeFromParent()
        
        guard let playerViewController else { return }
        
        addChild(playerViewController)
        
        playerViewController.view.frame = videoPlayerView.bounds
        playerViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        videoPlayerView.addSubview(playerViewController.view)
        
        playerViewController.didMove(toParent: self)
    }
    
    private func configurePlayer() {
        guard let videoUrls else { return }
                
        let currentUrl = videoUrls[currentIndex]
        
        player = AVPlayer(url: currentUrl)
        
        guard let playerViewController else { return }
        
        playerViewController.player = player
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(platNextVideo),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )
    }
    
    @objc
    private func platNextVideo() {
        guard hasNextVideo else {
            return
        }
        
        currentIndex += 1
        
        setupControlButtons()
        configurePlayer()
        
        self.player?.play()
    }
}
