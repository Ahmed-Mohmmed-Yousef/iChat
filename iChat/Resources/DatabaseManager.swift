//
//  DatabaseManager.swift
//  iChat
//
//  Created by Ahmed on 6/14/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
}


//MARK:- Account Managemnt

extension DatabaseManager {
    
    public func userExists(with email: String, completion: @escaping((Bool) -> Void)){
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        database.child(safeEmail).observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    /// insert new user to database
    public func insertUser(with user: ChatUser, completion: @escaping((Bool) -> Void)) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firsName,
            "last_name": user.lastName
            ]) { error, _ in
                guard error == nil else {
                    print("Fiald to write to database")
                    completion(false)
                    return
                }
                
                completion(true)
            }
    }
}

struct ChatUser {
    let firsName: String
    let lastName: String
    let emailAdress: String
    
    var safeEmail: String {
        var safeEmail = emailAdress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    var profilePictureFileName: String {
        return "\(safeEmail)_profile_picture.png"
    }
}
