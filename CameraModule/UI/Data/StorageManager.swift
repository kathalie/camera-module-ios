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
    
    @discardableResult
    func removeFile(at fileUrl: URL) -> Bool {
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            do {
                try FileManager.default.removeItem(at: fileUrl)
                print("File successfully deleted.")
                
                return true
            } catch {
                print("Error deleting file: \(error.localizedDescription)")
            }
        } else {
            print("File does not exist.")
        }
        
        return false
    }
    
    func getSavedPhotos() throws -> [URL]  {
        let documentsDirectory = getDocumentsDirectory()
        
        return try getFiles(at: documentsDirectory, with: "heic")
    }
    
    func getSavedVideos() throws -> [URL]  {
        let documentsDirectory = getDocumentsDirectory()
        
        return try getFiles(at: documentsDirectory, with: "mp4")
    }
    
    private func getFiles(at directory: URL, with pathExtension: String) throws -> [URL] {
        let allFiles = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
        
        let specificFiles = allFiles.filter { $0.pathExtension.lowercased() == pathExtension }
        
        return specificFiles.sorted(by: {$0.lastPathComponent < $1.lastPathComponent})
    }
}
