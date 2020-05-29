//
//  PersonInfoEditViewController.swift
//  LYDAppDevPortfolioTracker
//
//  Created by Lydia Zhang on 5/26/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import UIKit
import CoreData


class PersonInfoEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
     private var imagePath: String?
    
    var personController: PersonController?
    var person: Person? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        if let person = person, isViewLoaded {
            if person.image == nil {
                imageView.image = #imageLiteral(resourceName: "default")
            } else {

                imageView.image = UIImage(contentsOfFile: person.image!)
            }
            name.text = person.name
            github.text = person.github
            introduction.text = person.introduction ?? ""
            name.isUserInteractionEnabled = false
            github.isUserInteractionEnabled = false
            introduction.isUserInteractionEnabled = false
            edit.isEnabled = true
        } else if isViewLoaded {
            name.text = ""
            github.text = ""
            introduction.text = ""
            edit.title = ""
            edit.isEnabled = false
            name.isUserInteractionEnabled = true
            introduction.isUserInteractionEnabled = true
            github.isUserInteractionEnabled = true
            name.becomeFirstResponder()
        }
    }
    
// MARK: - Properties
    @IBOutlet var name: UITextField!
    @IBOutlet var github: UITextField!
    @IBOutlet var introduction: UITextView!
    
    @IBOutlet var chooseImageButton: UIButton!
    @IBOutlet var edit: UIBarButtonItem!
    @IBOutlet var imageView: UIImageView!
    
    var didSetImage: Bool = false
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any] ) {
        if didSetImage == true {
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                imageView.image = pickedImage
                imageView.contentMode = .scaleAspectFit
                let fm = FileManager.default
                let docURL = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
                let docPath = docURL.path
                let filePath = docURL.appendingPathComponent("profilePicture.png")
                
                do {
                    let files = try fm.contentsOfDirectory(atPath: "\(docPath)")
                    for file in files {
                        if "\(docPath)/\(file)" == filePath.path {
                            try fm.removeItem(atPath: filePath.path)
                        }
                    }
                } catch {
                    NSLog("Adding Image failed.")
                }
                
                do {
                    if let pngData = pickedImage.pngData() {
                        try pngData.write(to: filePath, options: .atomic)
                    }
                } catch {
                   NSLog("Writing image to file path failed")
                }
                
                imagePath = filePath.path
                
                didSetImage = false
                
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    @IBAction func editTapped(_ sender: Any) {
        name.isUserInteractionEnabled = true
        introduction.isUserInteractionEnabled = true
        github.isUserInteractionEnabled = true
        edit.title = ""
        edit.isEnabled = false
    }

    @IBAction func choosePicTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            didSetImage = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    @IBAction func goBackTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if let personController = personController {
            
            guard let name = name.text, !name.isEmpty, let github = github.text, !github.isEmpty, let intro = introduction.text else {return}
            
            if let person = person {
                
                personController.updatePerson(person: person, name: name, intro: intro, github: github, imagePath: imagePath)
            } else {
                personController.createPerson(name: name, github: github, intro: intro, imagePath: imagePath)
            }
        }
        //        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}
