//
//  Animation.swift
//  CameraModule
//
//  Created by Kathryn Verkhogliad on 24.11.2024.
//

import UIKit

class AnimationProvider {
    static let shared = AnimationProvider()
    private init() {}
    
    func zoomInAnimation(view: UIView, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            
            view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: { _ in
            completion()
            
            UIView.animate(withDuration: 0.2) {
                view.transform = .identity
            }
        })
    }
}
