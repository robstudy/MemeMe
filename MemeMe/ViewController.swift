//
//  ViewController.swift
//  MemeMe
//
//  Created by Robert Garza on 11/18/15.
//  Copyright © 2015 Robert Garza. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var pickImage: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextView: UITextView!
    @IBOutlet weak var bottomTextView: UITextView!
    let imagePicker = UIImagePickerController()
    
    let textAttributes = NSAttributedString(string: "Text", attributes:[
        NSStrokeColorAttributeName:UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
        NSStrokeWidthAttributeName: 10.0
        ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        topTextView.attributedText = textAttributes
        topTextView.textAlignment = NSTextAlignment.Center
        topTextView.textColor = UIColor.whiteColor()
        
        bottomTextView.attributedText = textAttributes
        bottomTextView.textAlignment = NSTextAlignment.Center
        bottomTextView.textColor = UIColor.whiteColor()

        imagePicker.delegate = self
        topTextView.delegate = self
        bottomTextView.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotification()
        print("\(topTextView.textColor)")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Actions
    
    //Pick From an Album
    @IBAction func pickAnImageFromAlbum(sender:AnyObject){
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        pickImage.contentMode = UIViewContentMode.ScaleAspectFill
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //Pick from a camera
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        pickImage.contentMode = UIViewContentMode.ScaleAspectFill
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - ImagePicker Delegate Controlls
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {

    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.pickImage.image = image
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: - TextView Delegate Controlls
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n"){
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    //Move Keyboard up so it doesn't cover the textField
    func keyboardWillShow(notification: NSNotification){
        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(notification: NSNotification){
        self.view.frame.origin.y += getKeyboardHeight(notification)
    }

    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as!NSValue //of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
}

