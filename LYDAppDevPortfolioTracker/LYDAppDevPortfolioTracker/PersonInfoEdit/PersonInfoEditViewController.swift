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
import MessageUI

class PersonInfoEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
    
    private var imagePath: String?
    private var isEditPressed: Bool = false
    var personController: PersonController?
    var person: Person? {
        didSet {
            updateViews()
        }
    }
    
    
    func updateViews() {
        self.view.backgroundColor = UIColor(displayP3Red: 0.737, green: 0.722, blue: 0.694, alpha: 1)
        self.introduction.layer.cornerRadius = 8
        self.introduction.layer.backgroundColor = CGColor(srgbRed: 0.957, green: 0.953, blue: 0.933, alpha: 0.4)
        self.introduction.layer.borderWidth = 2
        self.introduction.layer.borderColor = CGColor(srgbRed: 0.27, green: 0.25, blue: 0.23, alpha: 1.0)
        
        self.chooseImageButton.layer.cornerRadius = 5
        self.chooseImageButton.layer.backgroundColor = CGColor(srgbRed: 0.27, green: 0.25, blue: 0.23, alpha: 1.0)
        self.chooseImageButton.setTitleColor(UIColor(displayP3Red: 0.957, green: 0.953, blue: 0.933, alpha: 1), for: .normal)
        
        self.ShareButton.setTitleColor(UIColor(displayP3Red: 0.957, green: 0.953, blue: 0.933, alpha: 0.6), for: .normal)
        self.ShareButton.layer.backgroundColor = CGColor(srgbRed: 0.27, green: 0.25, blue: 0.23, alpha: 1.0)
        self.ShareButton.layer.cornerRadius = 8
        
        self.name.layer.borderColor = CGColor(srgbRed: 0.27, green: 0.25, blue: 0.23, alpha: 1.0)
        self.name.layer.borderWidth = 2
        self.name.layer.cornerRadius = 5
        self.name.backgroundColor = UIColor(displayP3Red: 0.957, green: 0.953, blue: 0.933, alpha: 0.5)
        
        self.github.backgroundColor = UIColor(displayP3Red: 0.957, green: 0.953, blue: 0.933, alpha: 0.5)
        self.github.layer.cornerRadius = 5
        self.github.layer.borderWidth = 2
        self.github.layer.borderColor = CGColor(srgbRed: 0.27, green: 0.25, blue: 0.23, alpha: 1.0)
        
        if let person = person, isViewLoaded {
//            if person.image == nil {
//                imageView.image = #imageLiteral(resourceName: "default")
//            } else {
//                let fm = FileManager.default
//                let docURL = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
//                let filePath = docURL.appendingPathComponent("\(person.image!)")
//
//                imageView.image = UIImage(contentsOfFile: filePath.path)
//            }
            name.text = person.name
            github.text = person.github
            introduction.text = person.introduction ?? ""
            name.isUserInteractionEnabled = false
            github.isUserInteractionEnabled = false
            chooseImageButton.isUserInteractionEnabled = false
            self.edit.title = "Edit"
            introduction.isUserInteractionEnabled = false
        } else if isViewLoaded {
            name.text = ""
            github.text = ""
            introduction.text = ""
            self.edit.title = "Save"
            name.isUserInteractionEnabled = true
            introduction.isUserInteractionEnabled = true
            chooseImageButton.isUserInteractionEnabled = true
            github.isUserInteractionEnabled = true
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
    @IBOutlet var ShareButton: UIButton!
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
                if userDefault.string(forKey: "token") == "" {
                    personController.createPerson(name: name, github: github, intro: intro, uuid: "")
                } else {
                    personController.createPersonFirebase(name: name, github: github, intro: intro, uuid: userDefault.string(forKey: "token"))
                }
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
                        if userDefault.string(forKey: "token") == "" {
                            personController.updatePerson(person: person, name: name, intro: intro, github: github)
                        } else {
                            personController.updatePersonFirebase(person: person, name: name, intro: intro, github: github)
                        }
                        
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
        if userDefault.string(forKey: "token") == "" {
            let alertController  = UIAlertController(title: "Login Needed", message: "Please login to upload profile image", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true)
        } else {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
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
//        let activityVC = UIActivityViewController(activityItems: [data], applicationActivities: [])
//        present(activityVC, animated: true, completion: nil)
        showMailComposer(person: person, data: data)
    }
    
    private func showMailComposer(person: Person, data: Data) {
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setSubject("\(String(describing: person.name))'s Portfolio")
        composer.setMessageBody("Here is my protfolio card!", isHTML: false)
        composer.addAttachmentData(data, mimeType: "pdf", fileName: "\(String(describing: person.name))")
        present(composer, animated: true)
    }
    
    @IBAction func goBackTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
