//
//  ViewController.swift
//  ImagePicker2
//
//  Created by Minoru Hayata on 2021/03/11.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var share: UIBarButtonItem!
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var camera: UIBarButtonItem!
    @IBOutlet weak var album: UIBarButtonItem!
    @IBOutlet weak var top: UITextField!
    @IBOutlet weak var bottom: UITextField!
    @IBOutlet weak var upperBar: UIToolbar!
    @IBOutlet weak var lowerBar: UIToolbar!
    
    let myTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black ,
        NSAttributedString.Key.strokeWidth: -2.0 ,
        NSAttributedString.Key.foregroundColor: UIColor.white ,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
    ]
    
/*
    // move out to outside file
    struct myMeme {
        var topText: String
        var bottomText: String
        let originalImage: UIImage
        let mymemeImage: UIImage
    }
 */
    
    override func viewDidLoad() {
        super.viewDidLoad()
/*
// chaned to function: setupTextField
        top.defaultTextAttributes = myTextAttributes
        bottom.defaultTextAttributes = myTextAttributes
        top.text = "TOP"
        bottom.text = "BOTTOM"
*/
        setupTextField(top, text: "TOP")
        setupTextField(bottom, text: "BOTTOM")

        share.isEnabled = false
        
        self.top.delegate = self
        self.bottom.delegate = self
    }
    
    func setupTextField(_ textField: UITextField, text: String){
        textField.defaultTextAttributes = myTextAttributes
        textField.text = text

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        camera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func pickAnImageFromCamera(_ sender: Any) {
/*
// Replaced with func presentPickerViewController()
         
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
*/
        presentPickerViewController(source: .camera)
        share.isEnabled = true
    }
    
    @IBAction func pickAnImageFromPhotoLibrary(_ sender: Any) {
/*
// Replaced with func presentPickerViewController()
         
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
 */
        presentPickerViewController(source: .photoLibrary)
        share.isEnabled = true
    }
    
    func presentPickerViewController(source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == top {
            top.text = ""
        } else if textField == bottom {
            bottom.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.frame.origin.y = 0
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottom.isEditing, view.frame.origin.y == 0 {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        return true
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func generatemyMemeImage() -> UIImage {
        //self.navigationController?.setToolbarHidden(true, animated: true)
        upperBar.isHidden = true
        lowerBar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let mymemeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //self.navigationController?.setToolbarHidden(false, animated: true)
        upperBar.isHidden = false
        lowerBar.isHidden = false
        
        return mymemeImage
    }
    
    func save() {
        let mymeme = myMeme(topText: top.text!, bottomText: bottom.text!, originalImage: imagePickerView.image!, mymemeImage: generatemyMemeImage())
    }
    
    
    @IBAction func shareAction(_ sender: Any) {
        let mymemeImage: UIImage = generatemyMemeImage()
        let shareSheet = UIActivityViewController(activityItems: [mymemeImage], applicationActivities: nil)
        shareSheet.completionWithItemsHandler = { (_, completed, _, _) in if (completed){
            self.save()
            }
        }
    present(shareSheet, animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        share.isEnabled = false
        imagePickerView.image = nil

// replace with function: setupTextField()
//        top.text = "TOP"
//        bottom.text = "BOTTOM"
        
        setupTextField(top, text: "TOP")
        setupTextField(bottom, text: "BOTTOM")

    }
    
    
    
    
}

