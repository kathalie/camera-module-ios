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
        static let goToPhotoPreviewSegue = "go_to_photo_preview"
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
            
            showAlert(title: "Failed to load gallery", message: "")
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let imageUrl = filePaths[.photos]![indexPath.row]
            
            performSegue(withIdentifier: Const.goToPhotoPreviewSegue, sender: imageUrl)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Const.goToPhotoPreviewSegue:
            let photoPreviewVC = segue.destination as! PhotoPreviewViewController
            let imageUrl = sender as! URL
            
            photoPreviewVC.config(imageUrl: imageUrl)
        default: break
        }
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
