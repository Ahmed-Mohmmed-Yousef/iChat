//
//  MainTabBar.swift
//  iChat
//
//  Created by Ahmed on 6/14/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import UIKit

class MainTabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTapBar()
        setupViewControllers()
    }
    
    
    private func setupTapBar(){
        self.tabBar.tintColor = .systemGreen
    }
    
    private func setupViewControllers(){
        let conversationVC = ConversationViewController()
        conversationVC.title = "Chats"
        let chatNavBarContriller = UINavigationController(rootViewController: conversationVC)
        chatNavBarContriller.navigationBar.tintColor = .systemBlue
        chatNavBarContriller.navigationBar.prefersLargeTitles = true
        chatNavBarContriller.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.systemBlue,
        ]
        let profileVC = ProfileViewController()
        profileVC.title = "Profile"
        let profileNavBarController = UINavigationController(rootViewController: profileVC)
        profileNavBarController.navigationBar.prefersLargeTitles = true
        profileNavBarController.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.systemBlue,
        ]
        self.viewControllers = [chatNavBarContriller, profileNavBarController]
        
    }

}
