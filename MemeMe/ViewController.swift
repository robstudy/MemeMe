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
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var topTextView: UITextView!
    @IBOutlet weak var bottomTextView: UITextView!
    @IBOutlet weak var picToolBar: UIToolbar!
    
    @IBOutlet weak var stateToolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var memeImage: UIImage?
    let imagePicker = UIImagePickerController()
    
    //MARK: - View Controls
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        let textAttributes = NSAttributedString(string: "TOP", attributes:[
            NSStrokeColorAttributeName:UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
            NSStrokeWidthAttributeName: -3.0
        ])
        
        topTextView.attributedText = textAttributes
        topTextView.textAlignment = NSTextAlignment.Center
        
        bottomTextView.attributedText = textAttributes
        bottomTextView.textAlignment = NSTextAlignment.Center
        bottomTextView.text = "BOTTOM"

        imagePicker.delegate = self
        topTextView.delegate = self
        bottomTextView.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotification()
        self.subscribeViewOrientation()
        
        if(pickImage.image == nil){
            shareButton.enabled = false
        } else {
            self.view.sendSubviewToBack(pickImage)
            shareButton.enabled = true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
        self.unsubscribeViewOrientation()
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
    
    @IBAction func cancelButton(sender: UIBarButtonItem){
        self.pickImage.image = nil
        topTextView.text = "TOP"
        bottomTextView.text = "BOTTOM"
        shareButton.enabled = false
    }
    
    //MARK: - ImagePicker Delegate Controlls
    
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
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n"){
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        //textView.autocorrectionType = .No
        textView.text = ""
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    //MARK: - Keyboard Notifications
    
    func keyboardWillShow(notification: NSNotification){
        if(bottomTextView.isFirstResponder()){
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        if(bottomTextView.isFirstResponder()){
            self.view.frame.origin.y += getKeyboardHeight(notification)
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
    
    //MARK: - Orientation notifications
    
    func changeBarButtonWidth(notification: NSNotification){
        shareButton.width = self.view.bounds.width/2.0
        cancelButton.width = self.view.bounds.width/2.0
        cameraButton.width = self.view.bounds.width/2.0
        albumButton.width = self.view.bounds.width/2.0
    }
    
    func subscribeViewOrientation(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeBarButtonWidth:", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    func unsubscribeViewOrientation(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    //MARK: - Meme Image functions
    
    func generateMemedImage()-> UIImage {
        
        //Hide ToolBars when generating image
        picToolBar.hidden = true
        stateToolBar.hidden = true
        
        //Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //UnHide ToolBars
        picToolBar.hidden = false
        stateToolBar.hidden = false
        
        return memedImage
    }
    
    func saveMeme(){
        let meme = Meme(tText: topTextView.text!, bText: bottomTextView.text!, img: pickImage.image!, memeImg: memeImage!)
    }
    
    @IBAction func shareImage(sender: UIBarButtonItem) {
        self.memeImage = generateMemedImage()
        
        let imageObject = [self.memeImage!]
        
        let shareImageVC = UIActivityViewController(activityItems: imageObject, applicationActivities: nil)
        /*Answer for how to fix view controller presentation on IPAD can be found at
        http://stackoverflow.com/questions/25644054/uiactivityviewcontroller-crashing-on-ios8-ipads
        */
        if(shareImageVC.respondsToSelector(Selector("popoverPresentationController"))){
            shareImageVC.popoverPresentationController?.sourceView = self.pickImage
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

