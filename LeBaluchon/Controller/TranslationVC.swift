//
//  TranslationVC.swift
//  LeBaluchon
//
//  Created by Daniel BENDEMAGH on 19/09/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class TranslationVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var fromLanguageButton: UIButton!
    @IBOutlet weak var toLanguageButton: UIButton!
    @IBOutlet weak var fromTextView: UITextView!
    @IBOutlet weak var toTextView: UITextView!
    
    var translationService = TranslationService()
    
    let languages = ["Français", "Anglais", "Chinois"]
    
    var test: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //translatedTextView.isEditable = false
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row]
    }
    
    @IBAction func TranslateButtonTapped(_ sender: UIButton) {
        //translate()
    }
    
    
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        fromTextView.resignFirstResponder()
    }
}
