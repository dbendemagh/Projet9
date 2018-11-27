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
    @IBOutlet weak var reverseButton: UIButton!
    
    var translationService = TranslationService()
    var picker = UIPickerView()
    
    var test: String = ""
    
    lazy var fromLangagePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    lazy var toLangagePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getLanguages()
        
        fromTextView.text = "Hello"
        toTextView.text = ""
        
        reverseButton.imageView?.contentMode = .scaleAspectFit
        
    }
    
    // Picker View for currency choice
    func setupCurrenciesPicker() {
//        fromLangagePicker.delegate = self
//        toLangagePicker.delegate = self
        
        fromLanguageTextView.inputView = fromLangagePickerView
        toLanguageTextView.inputView = toLangagePickerView
        fromLanguageTextView.isEnabled = true
        toLanguageTextView.isEnabled = true
    }
    
    // Add Done button to picker View
    func createToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ExchangeRateVC.endEditing))
        
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        fromLanguageTextView.inputAccessoryView = toolbar
        toLanguageTextView.inputAccessoryView = toolbar
    }
    
    func getLanguages() {
        let request = translationService.createLanguagesRequest()
        
        toggleActivityIndicator(shown: true)
        translationService.get(request: request) { (success, languagesList: LanguagesList?) in
            self.toggleActivityIndicator(shown: false)
            if success, let languageList = languagesList {
                self.translationService.languages = languageList.data.languages
                self.setupCurrenciesPicker()
                self.createToolbar()
            } else {
                self.displayAlert(title: "Network error", message: "Cannot retrieve languages list")
            }
        }
    }
    
    @objc func endEditing() {
        view.endEditing(true)
        translationService.fromLangage = translationService.languageCode(languageName: fromLanguageTextView.text!)
        translationService.toLangage = translationService.languageCode(languageName: toLanguageTextView.text!)
    }
    
    @IBAction func TranslateButtonTapped(_ sender: UIButton) {
        translate()
    }
    
    func translate() {
        guard let text = fromTextView.text, fromTextView.text != "" else {
            self.displayAlert(title: "No text", message: "Enter a text to translate")
            return
        }
        
        let request = translationService.createTranslationRequest(text: text)
        
        translationService.get(request: request) { (success, translation: Translation?) in
            if success, let translation = translation {
                self.toTextView.text = translation.data.translations[0].translatedText
            } else {
                self.displayAlert(title: "Network error", message: "Cannot retrieve translation")
            }
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        fromTextView.resignFirstResponder()
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        translateButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }
    
    @IBAction func reverseButtonTapped(_ sender: UIButton) {
        translationService.reverseLangages()
        
        let toLangage = fromLanguageTextView.text
        fromLanguageTextView.text = toLanguageTextView.text
        toLanguageTextView.text = toLangage
        
        let toText = fromTextView.text
        fromTextView.text = toTextView.text
        toTextView.text = toText
    }
}

extension TranslationVC: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return  translationService.languages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let currency = translationService.languages[row].name
        return currency
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currency = translationService.languages[row].name
        //originalCurrency = currency
        
        if pickerView == fromLangagePickerView {
            fromLanguageTextView.text = currency
        } else if pickerView == toLangagePickerView {
            toLanguageTextView.text = currency
        }
    }
}

