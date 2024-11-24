//
//  SectionHeader.swift
//  CameraModule
//
//  Created by Kathryn Verkhogliad on 24.11.2024.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    @IBOutlet weak var headerCaptionLabel: UILabel!
    
    func config(caption: String) {
        headerCaptionLabel.text = caption
    }
}
