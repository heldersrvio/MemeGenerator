//
//  ViewController.swift
//  MemeGenerator
//
//  Created by Helder on 03/13/2021.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectImageButton: UIButton!
    var pickedImage: UIImage?
    var topText: String?
    var bottomText: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        selectImageButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
    }
    
    @objc func pickImage() {
        let ipc = UIImagePickerController()
        ipc.delegate = self
        ipc.sourceType = .photoLibrary
        ipc.allowsEditing = false
        present(ipc, animated: true)
    }
    
    func drawMeme() {
        if let pickedImage = pickedImage {
            let renderer = UIGraphicsImageRenderer(size: pickedImage.size)
            let image = renderer.image { ctx in
                pickedImage.draw(in: CGRect(x: 0, y: 0, width: pickedImage.size.width, height: pickedImage.size.height))
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                let mainAttrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 400, weight: .bold),
                    .paragraphStyle: paragraphStyle,
                    .foregroundColor: UIColor.white,
                ]
                let outlineAttrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 400, weight: .bold),
                    .paragraphStyle: paragraphStyle,
                    .strokeWidth: 4,
                    .strokeColor: UIColor.black,
                ]
                if let topText = topText?.uppercased() {
                    let outlineAttributedString1 = NSAttributedString(string: topText, attributes: outlineAttrs)
                    outlineAttributedString1.draw(in: CGRect(x: 0, y: 0, width: pickedImage.size.width, height: pickedImage.size.height))
                    let attributedString1 = NSAttributedString(string: topText, attributes: mainAttrs)
                    attributedString1.draw(in: CGRect(x: 0, y: 0, width: pickedImage.size.width, height: pickedImage.size.height))
                }
                if let bottomText = bottomText?.uppercased() {
                    let outlineAttributedString2 = NSAttributedString(string: bottomText, attributes: outlineAttrs)
                    outlineAttributedString2.draw(in: CGRect(x: 0, y: pickedImage.size.height - 530, width: pickedImage.size.width, height: pickedImage.size.height))
                    let attributedString2 = NSAttributedString(string: bottomText, attributes: mainAttrs)
                    attributedString2.draw(in: CGRect(x: 0, y: pickedImage.size.height - 530, width: pickedImage.size.width, height: pickedImage.size.height))
                }
            }
            imageView.image = image
        }
    }
    
    func presentTopTextAlert() {
        let ac = UIAlertController(title: "Add a line to the top of the image", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "No, thanks", style: .cancel, handler: { (_action) in
            self.topText = nil
            self.dismiss(animated: true) {
                self.presentBottomTextAlert()
            }
        }))
        let addTextAction = UIAlertAction(title: "Add", style: .default, handler: { (_action) in
            if let text = ac.textFields?[0].text {
                self.topText = text
            }
            self.dismiss(animated: true) {
                self.presentBottomTextAlert()
            }
        })
        ac.addAction(addTextAction)
        present(ac, animated: true)
    }
    
    func presentBottomTextAlert() {
        let ac = UIAlertController(title: "Add a line to the bottom of the image", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "No, thanks", style: .cancel, handler: { (_action) in
            self.bottomText = nil
            self.dismiss(animated: true) {
                self.drawMeme()
            }
        }))
        let addTextAction = UIAlertAction(title: "Add", style: .default, handler: { (_action) in
            if let text = ac.textFields?[0].text {
                self.bottomText = text
            }
            self.dismiss(animated: true) {
                self.drawMeme()
            }
        })
        ac.addAction(addTextAction)
        present(ac, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            pickedImage = image
            dismiss(animated: true) {
                self.presentTopTextAlert()
            }
        } else {
            dismiss(animated: true)
        }
    }
}

