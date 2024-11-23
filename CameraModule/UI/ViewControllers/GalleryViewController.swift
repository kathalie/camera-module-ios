//
//  MediaGridViewController.swift
//  CameraModule
//
//  Created by Kathryn Verkhogliad on 22.11.2024.
//

import UIKit


class GalleryViewController: UICollectionViewController {
    struct Const {
        static let photoCellReuseIdentifier = "photo_cell"
        static let videoCellReuseIdentifier = "video_cell"
        static let goToCameraViewSegue = "go_to_camera_view"
    }
    
    struct NotificationName {
        static let needGalleryUpdate = NSNotification.Name("needGalleryUpdate")
    }
    
    enum Section: CaseIterable {
        case photos, videos
    }
    
    var filePaths: [Section: [URL]] = [
        .photos: [],
        .videos: []
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(loadGallery),
            name: NotificationName.needGalleryUpdate,
            object: nil
        )
        
        loadGallery()
    }
    
    @objc
    func loadGallery() {
        do {
            filePaths[.photos] = try FSService.shared.getSavedPhotos()
            
            collectionView.reloadData()
        } catch {
            print(error.localizedDescription)
            
            showErrorAlert(title: "Failed to load gallery", message: "")
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = Section.allCases[section]
        
        return filePaths[section]!.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //TODO different cells for different reuse identifiers
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.photoCellReuseIdentifier, for: indexPath) as! PhotoGalleryViewCell
        
        let imageURL = filePaths[.photos]![indexPath.row]
        
        cell.loadImage(from: imageURL)
        
        return cell
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3
        let height = width
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
