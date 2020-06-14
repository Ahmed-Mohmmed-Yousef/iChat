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
        database.child(email).observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    /// insert new user to database
    public func insertUser(with user: ChatAppUser) {
        database.child(user.emailAdress).setValue([
            "first_name": user.firsName,
            "last_name": user.lastName
        ])
    }
}

struct ChatAppUser {
    let firsName: String
    let lastName: String
    let emailAdress: String
}
