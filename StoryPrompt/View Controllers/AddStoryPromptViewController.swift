//
//  ViewController.swift
//  StoryPrompt
//
//  Created by Hayes Crowley on 1/4/21.
//

import UIKit
import PhotosUI

class AddStoryPromptViewController: UIViewController {
    @IBOutlet weak var nounTextField: UITextField!
    @IBOutlet weak var adjTextField: UITextField!
    @IBOutlet weak var verbTextField: UITextField!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var numberSlider: UISlider!
    
    @IBOutlet weak var storyPromptImageView: UIImageView!
    let storyPrompt = StoryPromptEntry()
    
    @IBAction func changeNumber(_ sender: UISlider) {
        numberLabel.text = "Number: \(Int(sender.value))"
        storyPrompt.number = Int(sender.value)
    }

    @IBAction func changeGenre(_ sender: UISegmentedControl) {
        
        if let genre = StoryPrompts.Genre(rawValue: sender.selectedSegmentIndex){
            storyPrompt.genre = genre
        }else {
            storyPrompt.genre = .scifi
        }
    }
    @IBAction func generateStoryPrompt(_ sender: Any) {
        updateStoryPrompt()
        if storyPrompt.isValid() {
            print(storyPrompt)

        }
        else {
            let alert = UIAlertController(title: "Invalid Story Prompt", message: "Please fill out all of the fields", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style:.default, handler: {_ in
            })
            alert.addAction(action)
            present(alert, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        numberSlider.value = 7.5
        storyPrompt.noun = "toaster"
        storyPrompt.adjective = "smelly"
        storyPrompt.verb = "burps"
        storyPrompt.number = Int(numberSlider.value)
        storyPromptImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeImage))
        storyPromptImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    // if touching outside of keyboard, close keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
        
    }

    func updateStoryPrompt() {
        storyPrompt.noun = nounTextField.text ?? ""
        storyPrompt.adjective = adjTextField.text ?? ""
        storyPrompt.verb = verbTextField.text ?? ""
        
    }
    
    // @objc allows swift to expose code to ObjC.
    @objc func changeImage(){
        if #available(iOS 14, *) {
            var configuration = PHPickerConfiguration()
            configuration.filter = .images
            configuration.selectionLimit = 1
            let controller = PHPickerViewController(configuration: configuration)
            controller.delegate = self
            present(controller, animated:true)
            
        } else {
            // Fallback on earlier versions
            let pickerController = UIImagePickerController()
            pickerController.sourceType = .savedPhotosAlbum
            present(pickerController, animated: true, completion: nil)

            
        }
    }
}
extension AddStoryPromptViewController: UITextFieldDelegate {
    // method on view controller for dismissing keyboard from text field object
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // resign first responder, notifies text field object that it should resign its status as the first responder to the event in the responder chain... sort of like event.stopPropagation ???
        textField.resignFirstResponder()
        updateStoryPrompt()
        return true
    }

}
@available(iOS 14, *)
extension AddStoryPromptViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        if !results.isEmpty {
            let result = results.first!
            let itemProvider = result.itemProvider
            itemProvider.loadObject(ofClass: UIImage.self){
                [weak self] image, error in
                guard let image = image as? UIImage else {
                    return
                }
                DispatchQueue.main.async {
                    self?.storyPromptImageView.image = image
                }
            }
        }
    }}


extension AddStoryPromptViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let originalImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.storyPromptImageView.image = originalImage
        DispatchQueue.main.async {
            self.storyPromptImageView.image = originalImage

        }
    }
}
