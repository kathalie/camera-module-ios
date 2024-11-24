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
        static let sectionHeaderReuseIdentifier = "section_header"
        static let goToCameraViewSegue = "go_to_camera_view"
        static let goToPhotoPreviewSegue = "go_to_photo_preview"
        static let goToVideoPreviewSegue = "go_to_video_preview"
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.photoCellReuseIdentifier, for: indexPath) as! PhotoGalleryViewCell
            
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.videoCellReuseIdentifier, for: indexPath) as! VideoGalleryViewCell
            
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
            
            performSegue(withIdentifier: Const.goToPhotoPreviewSegue, sender: imageUrl)
        } else if indexPath.section == 1 {
            performSegue(withIdentifier: Const.goToVideoPreviewSegue, sender: indexPath.row)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Const.sectionHeaderReuseIdentifier, for: indexPath) as! SectionHeader
        
        sectionHeader.config(caption: Section.allCases[indexPath.section].rawValue)
        
        return sectionHeader
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Const.goToPhotoPreviewSegue:
            let photoPreviewVC = segue.destination as! PhotoPreviewViewController
            let imageUrl = sender as! URL
            
            photoPreviewVC.config(imageUrl: imageUrl)
        case Const.goToVideoPreviewSegue:
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
