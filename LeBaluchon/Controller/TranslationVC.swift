//
//  TranslationVC.swift
//  LeBaluchon
//
//  Created by Daniel BENDEMAGH on 19/09/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class TranslationVC: UIViewController {

    @IBOutlet weak var fromLanguageTextView: UITextField!
    @IBOutlet weak var fromTextView: UITextView!
    @IBOutlet weak var toLanguageTextView: UITextField!
    @IBOutlet weak var toTextView: UITextView!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var translationService = TranslationService()
    var picker = UIPickerView()
    
    var test: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //translatedTextView.isEditable = false
        getLanguages()
        
        fromTextView.text = "Hello"
        toTextView.text = ""
        
    }
    
    func getLanguages() {
        let request = translationService.createLanguagesRequest()
        
        toggleActivityIndicator(shown: true)
        translationService.get(request: request) { (success, languagesList: LanguagesList?) in
            self.toggleActivityIndicator(shown: false)
            if success, let languageList = languagesList {
                self.translationService.languages = languageList.data.languages
    
            } else {
                // Alert
            }
        }
    }
    
    @IBAction func TranslateButtonTapped(_ sender: UIButton) {
        translate()
    }
    
    func translate() {
        guard let text = fromTextView.text else {
            // Alert
            return
        }
        
        guard let fromLanguage = fromLanguageTextView.text else {
            // Alert
            return
        }
        
        let source = translationService.languageCode(languageName: fromLanguage)
        
        guard let toLanguage = toLanguageTextView.text else {
            // Alert
            return
        }
        
        let target = translationService.languageCode(languageName: toLanguage)
        
        let request = translationService.createTranslationRequest(source: source, target: target, text: text)
        
        translationService.get(request: request) { (success, translation: Translation?) in
            if success, let translation = translation {
                self.toTextView.text = translation.data.translations[0].translatedText
                self.test = "ok"
            }
        }
        
        //translationService.getTranslation(source: fromLanguage, target: toLanguage, text: text)
        
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        fromTextView.resignFirstResponder()
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        translateButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }
}


