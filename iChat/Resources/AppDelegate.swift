//
//  AppDelegate.swift
//  iChat
//
//  Created by Ahmed on 6/13/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import GoogleSignIn


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) ->Bool {

        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        ) || GIDSignIn.sharedInstance().handle(url)

    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        // ...
        if let error = error {
            print("Fields to sign in with google: \(error.localizedDescription)")
          return
        }
        
        guard let user = user else { return }
        
        print("Did sign in with google: \(user)")
        
        guard let email = user.profile.email,
            let firstName = user.profile.givenName,
            let lastName = user.profile.familyName else {
                return
        }
        DatabaseManager.shared.userExists(with: email) { (exist) in
            if !exist {
                let chatUser = ChatUser(firsName: firstName,
                                           lastName: lastName,
                                           emailAdress: email)
                DatabaseManager.shared.insertUser(with: chatUser) { success in
                    if success {
                        // upload image
                        if user.profile.hasImage {
                            guard let url = user.profile.imageURL(withDimension: 200) else {
                                return
                            }
                            print(url)
                            URLSession.shared.dataTask(with: url) { (data, _, error) in
                                guard let data = data, error == nil else {
                                    print("Cant Download data from googlt: \(error!.localizedDescription)")
                                    return
                                }
                                print("got data from google, uploading data ")
                                // upload image
                                let fileName = chatUser.profilePictureFileName
                                StorageManeger.shared.uploadProfilePicture(with: data, fileName: fileName) { result in
                                    switch result {
                                        
                                    case .success(let downLoadedURL):
                                        UserDefaults.standard.set(downLoadedURL, forKey: "profile_picture_url")
                                        print(downLoadedURL)
                                    case .failure(let error):
                                        print("Storage Maneger Error ",error.localizedDescription)
                                    }
                                }
                                
                            }.resume()
                        }
                    }
                }
            }
        }

        guard let authentication = user.authentication else {
            print("Missing auth object off of google user")
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            guard authResult != nil, error == nil else {
                print("Field to log in with google credential")
                return
            }
            
            NotificationCenter.default.post(name: .didLogInNotification, object: nil)
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Google user was disconnected")
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

        


}
