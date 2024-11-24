//
//  MediaGridViewController.swift
//  CameraModule
//
//  Created by Kathryn Verkhogliad on 22.11.2024.
//

import UIKit


class GalleryViewController: UICollectionViewController {
    struct Const {
        struct ReuseIdentifiers {
            static let photoCell = "photo_cell"
            static let videoCell = "video_cell"
            static let sectionHeader = "section_header"
        }
        struct Segue {
            static let cameraView = "go_to_camera_view"
            static let photoPreview = "go_to_photo_preview"
            static let videoPreview = "go_to_video_preview"
        }
    }
    
    struct NotificationName {
        static let needGalleryUpdate = NSNotification.Name("needGalleryUpdate")
    }
    
    enum Section: String, CaseIterable {
        case photos = "Images"
        case videos = "Movies"
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
        
        NotificationCenter.default.post(name: GalleryViewController.NotificationName.needGalleryUpdate, object: nil)
    }
    
    @objc
    func loadGallery() {
        do {
            filePaths[.photos] = try StorageManager.shared.getSavedPhotos()
            filePaths[.videos] = try StorageManager.shared.getSavedVideos()
            
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
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.ReuseIdentifiers.photoCell, for: indexPath) as! PhotoGalleryViewCell
            
            let imageURL = filePaths[.photos]![indexPath.row]
            
            cell.config(url: imageURL) { [weak self] confirmationAction in
                self?.showAlert(
                    title: "Do you want to delete this file?",
                    message: "File deletion cannot be undone",
                    confirmAction: confirmationAction
                )
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.ReuseIdentifiers.videoCell, for: indexPath) as! VideoGalleryViewCell
            
            let videoUrl = filePaths[.videos]![indexPath.row]
            
            cell.config(url: videoUrl) { [weak self] confirmationAction in
                self?.showAlert(
                    title: "Do you want to delete this file?",
                    message: "File deletion cannot be undone",
                    confirmAction: confirmationAction
                )
            }
            
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let imageUrl = filePaths[.photos]![indexPath.row]
            
            performSegue(withIdentifier: Const.Segue.photoPreview, sender: imageUrl)
        } else if indexPath.section == 1 {
            performSegue(withIdentifier: Const.Segue.videoPreview, sender: indexPath.row)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Const.ReuseIdentifiers.sectionHeader, for: indexPath) as! SectionHeader
        
        sectionHeader.config(caption: Section.allCases[indexPath.section].rawValue)
        
        return sectionHeader
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Const.Segue.photoPreview:
            let photoPreviewVC = segue.destination as! PhotoPreviewViewController
            let imageUrl = sender as! URL
            
            photoPreviewVC.config(imageUrl: imageUrl)
        case Const.Segue.videoPreview:
            let videoPreviewVC = segue.destination as! VideoPreviewViewController
            let currentIndex = sender as! Int
            
            videoPreviewVC.config(videoUrls: filePaths[.videos]!, currentIndex: currentIndex)
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
