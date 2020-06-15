//
//  ViewController.swift
//  iChat
//
//  Created by Ahmed on 6/13/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import UIKit
import FirebaseAuth
import JGProgressHUD
class ConversationViewController: UIViewController {
    
    private lazy var spinner = JGProgressHUD(style: .dark)
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private lazy var noConversationLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "No Conversation"
        lbl.textAlignment = .center
        lbl.textColor = .gray
        lbl.font = .systemFont(ofSize: 20, weight: .medium)
        return lbl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                            target: self,
                                                            action: #selector(didTappedCompose))
        
        view.backgroundColor = .white
        addSubViews()
        setupTableView()
        fetchConversation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        vailedAuth()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func vailedAuth(){
        
        if Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        } 
    }
    
    @objc private func didTappedCompose(){
        let vc = NewConversationViewController()
        let navBar = UINavigationController(rootViewController: vc)
        present(navBar, animated: true)
    }
    
    private func addSubViews(){
        view.addSubview(tableView)
        view.addSubview(noConversationLbl)
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchConversation(){
        tableView.isHidden = false
    }
    
}

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Hello world!"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ChatViewController()
        vc.title = "Ahmed"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

