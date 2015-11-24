//
//  MemeMeViewController.swift
//  MemeMe
//
//  Created by Robert Garza on 11/18/15.
//  Copyright © 2015 Robert Garza. All rights reserved.
//

import UIKit

class MemeMeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var pickImage: UIImageView!
    @IBOutlet weak var topTextView: UITextView!
    @IBOutlet weak var bottomTextView: UITextView!
    @IBOutlet weak var picToolBar: UIToolbar!
    @IBOutlet weak var stateToolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    var memeImage: UIImage?
    let imagePicker = UIImagePickerController()
    
    //MARK: - View Controls
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        imagePicker.delegate = self
        setTextFields(topTextView, defaultText: "TOP")
        setTextFields(bottomTextView, defaultText: "BOTTOM")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotification()
        
        if(pickImage.image == nil){
            shareButton.enabled = false
        } else {
            view.sendSubviewToBack(pickImage)
            shareButton.enabled = true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Actions
    
    //Pick from an album
    @IBAction func pickAnImageFromAlbum(sender:AnyObject){
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        pickImage.contentMode = UIViewContentMode.ScaleAspectFill
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //Pick from a camera
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        pickImage.contentMode = UIViewContentMode.ScaleAspectFill
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //Cancel button resets screen to initial state
    @IBAction func cancelButton(sender: UIBarButtonItem){
        pickImage.image = nil
        topTextView.text = "TOP"
        bottomTextView.text = "BOTTOM"
        shareButton.enabled = false
    }
    
    //MARK: - ImagePicker Delegate Controls
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pickImage.image = image
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - TextView Delegate Controls
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n"){
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if(textView.text == "TOP" || textView.text == "BOTTOM"){
            textView.text = ""
        }
    }
    
    //MARK: - Keyboard Notifications
    
    func keyboardWillShow(notification: NSNotification){
        if(bottomTextView.isFirstResponder()){
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        if(bottomTextView.isFirstResponder()){
            view.frame.origin.y = 0
        }
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
    
    //MARK: - Meme Image functions
    
    func setTextFields(textField: UITextView, defaultText: String){
        
        let textAttributes = NSAttributedString(string: defaultText, attributes:[
            NSStrokeColorAttributeName:UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
            NSStrokeWidthAttributeName: -3.0
            ])
        
        textField.delegate = self
        textField.attributedText = textAttributes
        textField.textAlignment = NSTextAlignment.Center
        textField.autocapitalizationType = .AllCharacters
        textField.textAlignment = .Center
    }
    
    func generateMemedImage()-> UIImage {
        
        //Hide ToolBars when generating image
        picToolBar.hidden = true
        stateToolBar.hidden = true
        
        //Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //UnHide ToolBars
        picToolBar.hidden = false
        stateToolBar.hidden = false
        
        return memedImage
    }
    
    func saveMeme(){
        let meme = Meme(tText: topTextView.text!, bText: bottomTextView.text!, img: pickImage.image!, memeImg: memeImage!)
        print(meme.description)
    }
    
    @IBAction func shareImage(sender: UIBarButtonItem) {
        memeImage = generateMemedImage()
        
        let imageObject = [memeImage!]
        
        let shareImageVC = UIActivityViewController(activityItems: imageObject, applicationActivities: nil)
        /*Answer for how to fix view controller presentation on IPAD can be found at
        http://stackoverflow.com/questions/25644054/uiactivityviewcontroller-crashing-on-ios8-ipads
        */
        if(shareImageVC.respondsToSelector(Selector("popoverPresentationController"))){
            shareImageVC.popoverPresentationController?.sourceView = pickImage
        }
        presentViewController(shareImageVC, animated: true, completion: nil)
        shareImageVC.completionWithItemsHandler = {(activity: String?, completed: Bool, items: [AnyObject]?, error: NSError?) ->Void in
            if completed {
                self.saveMeme()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
}

