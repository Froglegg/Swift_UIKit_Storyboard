//
//  StoryPromptViewController.swift
//  StoryPrompt
//
//  Created by Hayes Crowley on 1/7/21.
//

import UIKit

class StoryPromptViewController: UIViewController {

    @IBOutlet weak var storyPromptTextView: UITextView!
    var storyPrompt = StoryPromptEntry()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storyPrompt.noun = "toaster"
        storyPrompt.verb = "swims"
        storyPrompt.adjective = "smelly"
        storyPrompt.number = 7
        
        storyPromptTextView.text = storyPrompt.description
        // Do any additional setup after loading the view.
    }
    // lifecycle methods
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
