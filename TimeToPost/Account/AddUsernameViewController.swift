//
//  AddUsernameViewController.swift
//  TimeToPost
//
//  Created by Uzair Ishaq on 14/04/2019.
//  Copyright © 2019 Uzair Ishaq. All rights reserved.
//

import UIKit

protocol AddUsernameDisplayLogic: class {
    func displayAddUsername(with leftBarButton: UIBarButtonItem, rightBarButton: UIBarButtonItem)
    func displayLoadingUsername(with leftBarButton: UIBarButtonItem, rightBarButton: UIBarButtonItem)
    func displayUpdateUsername(with username: String, leftBarButton: UIBarButtonItem, rightBarButton: UIBarButtonItem)
    func displayAlert(title: String, message: String)
}

class AddUsernameViewController: UIViewController, AddUsernameDisplayLogic {
    
    // MARK: properties
    
    @IBOutlet weak var usernameTextField: UITextField!
    var interactor: AddUsernameInteractor?
    var presenter: AddUsernamePresenter?
    
    // MARK: object life cycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let viewController = self
        let interactor = AddUsernameInteractor()
        let presenter = AddUsernamePresenter()
        viewController.interactor = interactor
        viewController.presenter = presenter
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    // MARK: view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.becomeFirstResponder()
        interactor?.LoadUsername()
    }
    
    // MARK: actions
    
    @objc func doneTapped() {
        guard let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !username.isEmpty else {
            return
        }
        usernameTextField.resignFirstResponder()
        interactor?.validateUsername(with: username)
    }
    
    @objc func cancelTapped(){
        usernameTextField.text = ""
        interactor?.deleteUsername()
    }
    
    func displayAddUsername(with leftBarButton: UIBarButtonItem, rightBarButton: UIBarButtonItem) {
        usernameTextField.isEnabled = true
        navigationItem.hidesBackButton = false
        navigationItem.setLeftBarButton(nil, animated: true)
        navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    func displayLoadingUsername(with leftBarButton: UIBarButtonItem, rightBarButton: UIBarButtonItem) {
        usernameTextField.isEnabled = false
        navigationItem.setLeftBarButton(leftBarButton, animated: true)
        navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    func displayUpdateUsername(with username: String, leftBarButton: UIBarButtonItem, rightBarButton: UIBarButtonItem) {
        usernameTextField.text = username
        usernameTextField.isEnabled = true
        usernameTextField.becomeFirstResponder()
        navigationItem.hidesBackButton = false
        navigationItem.setLeftBarButton(nil, animated: true)
        navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: AppConfiguration.Messages.okButton, style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    

}
