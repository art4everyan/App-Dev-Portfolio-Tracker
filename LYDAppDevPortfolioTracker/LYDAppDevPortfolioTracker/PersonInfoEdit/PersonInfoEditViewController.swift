//
//  PersonInfoEditViewController.swift
//  LYDAppDevPortfolioTracker
//
//  Created by Lydia Zhang on 5/26/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import UIKit
import CoreData
import PDFKit

class PersonInfoEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var imagePath: String?
    private var isEditPressed: Bool = false
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
                let fm = FileManager.default
                let docURL = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
                let filePath = docURL.appendingPathComponent("\(person.image!)")
                //let x = filePath.path
                imageView.image = UIImage(contentsOfFile: filePath.path)
            }
            name.text = person.name
            github.text = person.github
            introduction.text = person.introduction ?? ""
            name.isUserInteractionEnabled = false
            github.isUserInteractionEnabled = false
            chooseImageButton.isUserInteractionEnabled = false
            self.edit.title = "Edit"
            introduction.isUserInteractionEnabled = false
            introduction.layer.cornerRadius = 20
            chooseImageButton.layer.cornerRadius = 5
        } else if isViewLoaded {
            name.text = ""
            github.text = ""
            introduction.text = ""
            self.edit.title = "Save"
            name.isUserInteractionEnabled = true
            introduction.isUserInteractionEnabled = true
            chooseImageButton.isUserInteractionEnabled = true
            github.isUserInteractionEnabled = true
            introduction.layer.cornerRadius = 20
            chooseImageButton.layer.cornerRadius = 5
            name.becomeFirstResponder()
            didSetImage = false
        }
    }
    
// MARK: - Properties
    @IBOutlet var name: UITextField!
    @IBOutlet var github: UITextField!
    @IBOutlet var introduction: UITextView!
    
    @IBOutlet var chooseImageButton: UIButton!
    @IBOutlet var edit: UIBarButtonItem!
    @IBOutlet var imageView: UIImageView!
    
    var didSetImage: Bool?
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any] ) {
        
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
            
            imagePath = "profilePicture.png"
                           
        }
        if imagePath != nil {
           didSetImage = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    @IBAction func editTapped(_ sender: Any) {
        if isEditPressed == false && self.edit.title == "Save" {
            if let personController = personController {
                guard let name = name.text, !name.isEmpty, let github = github.text, !github.isEmpty, let intro = introduction.text else {
                    let alert = UIAlertController(title: "Saving failed", message: "Please fill out all required field", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "Back", style: .default, handler: nil)
                    alert.addAction(alertAction)
                    self.present(alert, animated: true)
                    return
                }
                if imagePath != nil {
                   didSetImage = true
                }
                personController.createPerson(name: name, github: github, intro: intro, imagePath: imagePath)
                dismiss(animated: true, completion: nil)
            }
        } else {
            isEditPressed.toggle()
            if isEditPressed {
                chooseImageButton.isUserInteractionEnabled = true
                name.isUserInteractionEnabled = true
                introduction.isUserInteractionEnabled = true
                github.isUserInteractionEnabled = true
                edit.title = "Save"
            } else {

                if let personController = personController {
                    
                    guard let name = name.text, !name.isEmpty, let github = github.text, !github.isEmpty, let intro = introduction.text else {
                        let alert = UIAlertController(title: "Saving failed", message: "Please fill out all required field", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "Back", style: .default, handler: nil)
                        alert.addAction(alertAction)
                        self.present(alert, animated: true)
                        isEditPressed = true
                        return
                    }
                    
                    if let person = person {
                        if imagePath != nil {
                           didSetImage = true
                        }
                        personController.updatePerson(person: person, name: name, intro: intro, github: github, imagePath: imagePath)
                    }
                    
                }
                name.isUserInteractionEnabled = false
                introduction.isUserInteractionEnabled = false
                github.isUserInteractionEnabled = false
                chooseImageButton.isUserInteractionEnabled = false
                edit.title = "Edit"
            }
        }
        
    }

    @IBAction func choosePicTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    @IBAction func shareTapped(_ sender: Any) {
        guard let person = person else { return }
        guard let name = person.name,
            !name.isEmpty,
            let github = person.github,
            !github.isEmpty,
            let intro = person.introduction else {return}
        
        let pdf = PDF(name: name, intro: intro, github: github)
        let data = pdf.createPDF()
        let activityVC = UIActivityViewController(activityItems: [data], applicationActivities: [])
        present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func goBackTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
