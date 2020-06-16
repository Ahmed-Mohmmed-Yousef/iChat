//
//  StorageManeger.swift
//  iChat
//
//  Created by Ahmed on 6/15/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import Foundation
import FirebaseStorage

final class StorageManeger{
    
    static let shared = StorageManeger()
    
    private let storage = Storage.storage().reference()
    
    /*
     images/ahmed-gmail-com_profile_picture.png
    */
    
    public typealias uploadPictureComoletion = (Result<String, StorageError>) -> Void
    
    /// Uploading profile picture to firebase storage and return completion with url
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping uploadPictureComoletion){
        storage.child("images/\(fileName)").putData(data, metadata: nil) { (metadata, error) in
            guard error == nil else {
                print("Failds to upload picture to storage: \(error!.localizedDescription)")
                completion(.failure(.faildToUpload))
                return
            }
            
            self.storage.child("images/\(fileName)").downloadURL { (url, error) in
                guard let url = url else {
                    print("")
                    completion(.failure(.faildToGetDownloadURL))
                    return
                }
                let urlString = url.absoluteString
                print("downloaded url returnd back: \(urlString)")
                completion(.success(urlString))
            }
        }
    }
    
    public enum StorageError: Error {
        case faildToUpload
        case faildToGetDownloadURL
    }
}
