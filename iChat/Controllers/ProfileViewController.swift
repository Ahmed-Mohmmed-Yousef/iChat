//
//  ProfileViewController.swift
//  iChat
//
//  Created by Ahmed on 6/13/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class ProfileViewController: UIViewController {
        
    private lazy var tableView: UITableView = {
        let tabl = UITableView()
        return tabl
    }()
    
    let data = ["Log Out"]


    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupTableView()
    }

    private func setupTableView(){
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let alert = UIAlertController(title: "Sign Out",
                                      message: "Are you sure to sign out ?",
                                      preferredStyle: .actionSheet)
        let yeaAction = UIAlertAction(title: "yes", style: .destructive) {[weak self] _ in
            guard let self = self else { return }
            self.signOut()
        }
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel)
        
        alert.addAction(yeaAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    fileprivate func signOut() {
        // facebook log out
        FBSDKLoginKit.LoginManager().logOut()
        
        // google log out
        GIDSignIn.sharedInstance()?.signOut()
        
        do {
            try Auth.auth().signOut()
            
            if Auth.auth().currentUser == nil {
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                present(nav, animated: true, completion: nil)
            }
            
        } catch {
            print("Sign out error ")
        }
    }
}
