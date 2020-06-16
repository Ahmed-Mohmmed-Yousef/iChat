//
//  LoginViewController.swift
//  iChat
//
//  Created by Ahmed on 6/13/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
import JGProgressHUD

class LoginViewController: UIViewController {
    
    private lazy var spinner = JGProgressHUD(style: .dark)
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "text.bubble.fill")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Enter email"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private lazy var passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Enter password"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        return field
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        return button
    }()
    
    private lazy var facebookLoginBtn: FBLoginButton = {
        let button = FBLoginButton()
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.delegate = self
        button.permissions = ["public_profile", "email"]
        return button
    }()
    
    private lazy var googleLoginBtn: GIDSignInButton = {
        let button = GIDSignInButton()
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        return button
    }()
    
    private var loginObserver: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login Page"
        view.backgroundColor = .white
        
        loginObserver = NotificationCenter.default.addObserver(forName: .didLogInNotification,
                                                               object: nil,
                                                               queue: .main,
                                                               using: {[weak self] (_) in
                                                                guard let self = self else { return }
                                                                self.navigationController?.dismiss(animated: true)
                                                                
        })
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapped))
        
        loginButton.addTarget(self,
                              action: #selector(loginButtonTapped),
                              for: .touchUpInside)
        
        // set textFields delegate
        emailField.delegate = self
        passwordField.delegate = self
        
        // add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(facebookLoginBtn)
        scrollView.addSubview(googleLoginBtn)
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.frame = view.bounds
        let size = view.width / 3
        imageView.frame = CGRect(x: (scrollView.width - size) / 2,
                                 y: 20,
                                 width: size,
                                 height: size)
        
        emailField.frame = CGRect(x: 30,
                                  y: imageView.bottom + 10,
                                  width: scrollView.width - 60,
                                  height: 52)
        
        passwordField.frame = CGRect(x: 30,
                                     y: emailField.bottom + 10,
                                     width: scrollView.width - 60,
                                     height: 52)
        
        loginButton.frame = CGRect(x: 30,
                                   y: passwordField.bottom + 10,
                                   width: scrollView.width - 60,
                                   height: 52)
        
        //facebook login button
        facebookLoginBtn.frame = CGRect(x: 30,
                                        y: loginButton.bottom + 10,
                                        width: scrollView.width - 60,
                                        height: 52)
        
        //google login button
        googleLoginBtn.frame = CGRect(x: 30,
                                        y: facebookLoginBtn.bottom + 10,
                                        width: scrollView.width - 60,
                                        height: 52)
        
        
    }
    
    @objc private func loginButtonTapped(){
        guard let email = emailField.text,
            let password = passwordField.text,
            !email.isEmpty, !password.isEmpty,
            password.count >= 6
            else {
                alertUserLoginError()
                return
        }
        // firebase login
        spinner.show(in: view)
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authResult, error) in
            guard let self = self else { return }
            guard authResult != nil , error == nil else {
                print("Error login")
                return
            }
            
            DispatchQueue.main.async {
                self.spinner.dismiss()
            }
            
            self.navigationController?.dismiss(animated: true)
        }
    }
    
    private func alertUserLoginError(){
        let alert = UIAlertController(title: "Wooops",
                                      message: "Please, enter all info to log in",
                                      preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss",
                                          style: .cancel)
        alert.addAction(dismissAction)
        present(alert, animated: true)
    }
    
    @objc private func didTapped(){
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else {
            view.endEditing(true)
            loginButtonTapped()
        }
        
        return true
    }
}

extension LoginViewController: LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        // no opreation
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
          print(error.localizedDescription)
          return
        }
        
        let token: String = AccessToken.current!.tokenString
        
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                         parameters: ["fields": "email, first_name, last_name, picture.type(large)"],
                                                         tokenString: token,
                                                         version: nil,
                                                         httpMethod: .get)
        facebookRequest.start { (_, result, error) in
            guard let result = result as? [String: Any], error == nil else {
                print("Fields to make facebook graph request")
                return
            }
            
            guard let firstName = result["first_name"] as? String,
                let lastName = result["last_name"] as? String,
                let email = result["email"] as? String,
                let picture = result["picture"] as? [String: Any],
                let data = picture["data"] as? [String: Any],
            let pictureURL = data["url"] as? String else {
                    print("Fields to get username and email")
                    return
            }
            
            print(pictureURL)
            
            let chatUser = ChatUser(firsName: firstName, lastName: lastName, emailAdress: email)
            
            DatabaseManager.shared.userExists(with: email) { (exist) in
                if !exist {
                    DatabaseManager.shared.insertUser(with: chatUser) { success in
                        if success {
                            guard let url = URL(string: pictureURL) else {
                                return
                            }
                            print("Downloading data from facebook")
                            
                            URLSession.shared.dataTask(with: url) { (data, _, _) in
                                guard let data = data else {
                                    print("Cant Download data from facebook")
                                    return
                                }
                                print("got data from facebook, uploading data ")
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
        
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            Auth.auth().signIn(with: credential) {[weak self] (authResult, error) in
                guard let self = self else { return }
                guard authResult != nil, error == nil else {
                    print("Facebook credential login fields, MFA my be needed: \(error!.localizedDescription)")
                    return
                }
                self.navigationController?.dismiss(animated: true)
            }
        
        }
        
        
        
        
    }
    
    
}
