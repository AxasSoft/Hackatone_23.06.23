//
//  AuthController.swift
//  hackathon
//
//

import Foundation
import UIKit
import Toast
import PromiseKit
import IQKeyboardManagerSwift

final class AuthController: UIViewController {
  
    private let model = InitialModel()
    @IBOutlet private weak var loginTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.enable = true
    }
    
    
    @IBAction private func loginButtonTapped() {
//        if loginTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
//            view.makeToast("Введите логин")
//            return
//        }
//        
//        if passwordTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
//            view.makeToast("Введите пароль")
//            return
//        }
//        
//        guard let login = loginTextField.text else { return }
//        guard let password = loginTextField.text else { return }
        
//        firstly {
//            model.auth(login: login, password: password)
//        }.done { data in
//            if data.message?.lowercased() == "ok" {
//                NetworkManager.accessToken = data.data?.accessToken
//                self.presentNextController()
//            } else {
//                self.view.makeToast(data.description)
//            }
//        }.catch { error in
//            print(error.localizedDescription)
//            self.view.makeToast("Что-то пошло нет так")
//        }
        presentNextController()
    }
  
    private func presentNextController() {
        guard let tabBarController = UIStoryboard(name: "Tabbar", bundle: nil).instantiateInitialViewController() else
        { return }
        tabBarController.modalPresentationStyle = .overFullScreen
        tabBarController.modalTransitionStyle = .coverVertical
        self.present(tabBarController, animated: true)
    }
    
}
