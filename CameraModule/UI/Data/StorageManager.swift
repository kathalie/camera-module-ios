//
//  FSService.swift
//  CameraModule
//
//  Created by Kathryn Verkhogliad on 22.11.2024.
//

import Foundation
import Photos

class StorageManager {
    static let shared = StorageManager()
    
    private init() {}
    
    let photoDirectory = "images"
    let videlDirectory = "movies"
    
    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func saveImage(_ data: Data) throws {
        let fileUrl = getDocumentsDirectory()
            .appendingPathComponent("IMG\(Date.now).heic")
        
        try data.write(to: fileUrl)
        
        print("Image saved to: \(fileUrl)")
    }
    
    func getSavedPhotos() throws -> [URL]  {
        let documentsDirectory = getDocumentsDirectory()
        
        let allFiles = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
        
        let heicFiles = allFiles.filter { $0.pathExtension.lowercased() == "heic" }
        
        return heicFiles.sorted(by: {$0.lastPathComponent < $1.lastPathComponent})
    }
    
    func getSavedVideos() throws -> [URL]  {
        let documentsDirectory = getDocumentsDirectory()
        
        let allFiles = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
        
        let mp4Files = allFiles.filter { $0.pathExtension.lowercased() == "mp4" }
        
        return mp4Files.sorted(by: {$0.lastPathComponent < $1.lastPathComponent})
    }
}