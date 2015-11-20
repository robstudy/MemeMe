//
//  ViewController.swift
//  MemeMe
//
//  Created by Robert Garza on 11/18/15.
//  Copyright © 2015 Robert Garza. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var pickImage: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextView: UITextView!
    @IBOutlet weak var inputTopText: UITextField!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        pickImage.layer.borderColor = UIColor.blackColor().CGColor
        pickImage.layer.borderWidth = 3.0
        topTextView.backgroundColor = UIColor.clearColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pickImage(sender: UIBarButtonItem) {
        imagePicker.delegate = self
        self .presentViewController(imagePicker, animated: true, completion: nil)
        
        print("pressed")
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
    
    
    //Pick From an Album
    @IBAction func pickAnImageFromAlbum(sender:AnyObject){
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        pickImage.contentMode = UIViewContentMode.ScaleAspectFill
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //Pick from a camera
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        pickImage.contentMode = UIViewContentMode.ScaleAspectFill
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func editTopText(sender: AnyObject) {
        inputTopText.delegate = self
        textFieldShouldReturn(inputTopText)
        topTextView.text = inputTopText.text

    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //When imagePickerController finishes push text to front
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        topTextView.bringSubviewToFront(pickImage)
    }
    

}

