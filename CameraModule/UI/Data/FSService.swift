//
//  FSService.swift
//  CameraModule
//
//  Created by Kathryn Verkhogliad on 22.11.2024.
//

import Foundation

class FSService {
    static let shared = FSService()
    
    private init() {}
    
    let photoDirectory = "images"
    let videlDirectory = "movies"
    
    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func saveImage(_ data: Data) throws {
        let fileUrl = getDocumentsDirectory()
            .appendingPathComponent("IMG\(UUID().uuidString).heic")
        
        try data.write(to: fileUrl)
        
        print("Image saved to: \(fileUrl)")
    }
    
    func getSavedPhotos() throws -> [URL]  {
        let documentsDirectory = getDocumentsDirectory()
        
        let allFiles = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
        
        let heicFiles = allFiles.filter { $0.pathExtension.lowercased() == "heic" }
        
        return heicFiles
    }
}
