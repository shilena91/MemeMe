//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Hoang on 29.3.2020.
//  Copyright © 2020 Hoang. All rights reserved.
//

import UIKit

class MemeImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var topBar: UINavigationBar!
    @IBOutlet weak var bottomBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    var toolBar: UIToolbar!
    var navBar: UINavigationBar!
    
    let memeTextAttributes : [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3,
    ]
    
    var activeTextField: UITextField? = nil
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        subcribeToKeyboardNotification()
        configureUI()
    }
        
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unsubcribeToKeyboardNotification()
    
    }
    
    // MARK: IB actions functions
    
    @IBAction func shareTapped(_ sender: UIBarButtonItem) {
        let image = generateMemedImage()
        
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.completionWithItemsHandler = { (activity, success, items, errors) in
            if (success) {
                self.save()
            }
        }
        present(vc, animated: true)
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func toolBarButtonTapped(_ sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = (sender.tag == 0) ? .camera : .photoLibrary
        present(imagePicker, animated: true)
    }
    
    // MARK: Configure UI
    
    func configureUI() {
                
        configureTextField(textField: topTextField, withText: "TOP")
        configureTextField(textField: bottomTextField, withText: "BOTTOM")
        
        imageView.image = nil
        navigationController?.isNavigationBarHidden = true
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)

        updateShareButton()
    }
    
    func configureTextField(textField: UITextField, withText text: String) {
        textField.text = text
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    func updateShareButton() {
        shareButton.isEnabled = (imageView.image != nil)
    }
        
    
    // MARK: Pick and Save Image Functions
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        imageView.image = image
        dismiss(animated: true)
        updateShareButton()
    }
    
    func generateMemedImage() -> UIImage {
        
        hideTopAndBottomBar(true)
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
            
        hideTopAndBottomBar(false)
        
        return memedImage
    }
    
    func hideTopAndBottomBar(_ hide: Bool) {
        topBar.isHidden = hide
        bottomBar.isHidden = hide
    }
    
    func save() {
        
        let memedImage = generateMemedImage()
        let originalImage = imageView.image
        
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: originalImage!, memeImage: memedImage)
        
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }

    
    // MARK: TextField Delegates functions
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        activeTextField = textField
        textField.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Screen fit when keyboard appear and hide functions
    
    func subcribeToKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubcribeToKeyboardNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // The view moves up only if its hidden by keyboard
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        let keyboardHeight = getKeyboardHeight(notification)
        var shouldMoveViewUp = false
        
        if let activeTextField = activeTextField {
            
            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY
            let topOfKeyboard = view.frame.height - keyboardHeight
            
            if bottomOfTextField > topOfKeyboard {
                shouldMoveViewUp = true
            }
        }
        if shouldMoveViewUp {
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        
        if view.frame.origin.y != 0 {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyBoardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyBoardSize.cgRectValue.height
    }
}

