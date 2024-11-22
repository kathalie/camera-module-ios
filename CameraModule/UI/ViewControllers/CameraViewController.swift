//
//  CaptureViewController.swift
//  CameraModule
//
//  Created by Kathryn Verkhogliad on 22.11.2024.
//

import UIKit
import AVKit
import AVFoundation

class CameraViewController: UIViewController {
    struct Const {
        static let captureModeReuseIdentifier = "capture_mode"
        static let colorPhotoModeBorder: UIColor = UIColor.gray
        static let colorPhotoModeBackground: UIColor? = nil
        static let colorVideoModeBorder: UIColor = UIColor.systemPink
        static let colorVideoModeBackground: UIColor = UIColor.red
        static let captureBorderWidth = CGFloat(6)
    }
    
    enum CapturingMode {
        case photo
        case video(recording: Bool = false)
        
        var rawValue: String {
            switch self {
            case .photo: return "Photo"
            case .video: return "Video"
            }
        }
        
        static var current: CapturingMode = .photo
    }
    
    enum CameraPosition {
        case front
        case back
    }
 
    let rectangle = UIView()
    var cameraPosition: CameraPosition = .back
    
    @IBOutlet private weak var cameraPreview: UIView!
    @IBOutlet private weak var captureButton: UIButton!
    @IBOutlet weak var capturingModesSegmentedView: UISegmentedControl!
    
    @IBAction private func changeCameraPosition(_ sender: Any) {
        switch cameraPosition {
        case .back: cameraPosition = .front
        case .front: cameraPosition = .back
        }
    }
    
    @IBAction private func capture(_ sender: UIButton) {
        print("Capturing in \(CapturingMode.current)")
        toggleRecording()
        setupUI()
        
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                sender.transform = .identity
            }
        }
    }
    
    private func toggleRecording() {
        switch CapturingMode.current {
        case .video(let isRecording): 
            CapturingMode.current = .video(recording: !isRecording)
        default: return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialUiSetup()
        setupUI()
    }
    
    //MARK: initial UI setup
    
    private func initialUiSetup() {
        initialRectangleSetup()
        initialCapturingModesSegmentedViewSetup()
        initialCaptureButonSetup()
    }
    
    private func initialRectangleSetup() {
        rectangle.backgroundColor = Const.colorVideoModeBackground
        rectangle.translatesAutoresizingMaskIntoConstraints = false
        rectangle.layer.cornerRadius = 5
        rectangle.isUserInteractionEnabled = false
        captureButton.addSubview(rectangle)
    }
    
    private func initialCapturingModesSegmentedViewSetup() {
        let photoAction = UIAction(title: CapturingMode.photo.rawValue) {[weak self] _ in
            CapturingMode.current = .photo
            self?.setupUI()
        }
        let videoAction = UIAction(title: CapturingMode.video(recording: false).rawValue) {[weak self] _ in
            CapturingMode.current = .video(recording: false)
            self?.setupUI()
        }
        
        capturingModesSegmentedView.setAction(photoAction, forSegmentAt: 0)
        capturingModesSegmentedView.setAction(videoAction, forSegmentAt: 1)
    }
    
    private func initialCaptureButonSetup() {
        let captureButtonWidth = captureButton.frame.width
        
        captureButton.layer.cornerRadius = captureButtonWidth / 2
        captureButton.layer.borderWidth = Const.captureBorderWidth
        
        setupCaptureButton()
        NSLayoutConstraint.activate([
            rectangle.centerXAnchor.constraint(equalTo: captureButton.centerXAnchor),
            rectangle.centerYAnchor.constraint(equalTo: captureButton.centerYAnchor),
            rectangle.widthAnchor.constraint(equalTo: captureButton.widthAnchor, multiplier: 0.5),
            rectangle.heightAnchor.constraint(equalTo: captureButton.heightAnchor, multiplier: 0.5)
        ])
    }
    
    
    //MARK: Changing capturing mode
    
    private func setupUI() {
        setupCaptureButton()
    }
    
    private func setupCaptureButton() {
        switch CapturingMode.current {
        case .photo:
            captureButton.layer.borderColor = Const.colorPhotoModeBorder.cgColor
            captureButton.layer.backgroundColor = Const.colorPhotoModeBackground?.cgColor
            rectangle.backgroundColor = nil
            
        case .video(let isRecording):
            captureButton.layer.borderColor = Const.colorVideoModeBorder.cgColor
            
            if isRecording {
                captureButton.layer.backgroundColor = nil
                rectangle.backgroundColor = Const.colorVideoModeBackground
            } else {
                captureButton.layer.backgroundColor = Const.colorVideoModeBackground.cgColor
                rectangle.backgroundColor = nil
            }
        }
    }
}
