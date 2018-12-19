//
//  TranslationVC.swift
//  LeBaluchon
//
//  Created by Daniel BENDEMAGH on 19/09/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class TranslationVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var fromLanguageTextView: UITextField!
    @IBOutlet weak var fromTextView: UITextView!
    @IBOutlet weak var toLanguageTextView: UITextField!
    @IBOutlet weak var toTextView: UITextView!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var swapLanguagesButton: UIButton!
    
    // MARK: - Properties
    
    var translationService = TranslationService()
    var picker = UIPickerView()
    
    // Pickers for language selection
    lazy var fromLanguagePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    lazy var toLanguagePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    // MARK: - Init methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLanguages()
        
        setDisplay()
    }
    
    func setDisplay() {
        fromTextView.text = "Hello"
        toTextView.text = ""
        
        swapLanguagesButton.imageView?.contentMode = .scaleAspectFit
    }
    
    // Picker View for currency choice
    func setupCurrenciesPicker() {
        fromLanguageTextView.inputView = fromLanguagePickerView
        toLanguageTextView.inputView = toLanguagePickerView
        // Enable selection only when languages are loaded
        fromLanguageTextView.isEnabled = true
        toLanguageTextView.isEnabled = true
    }
    
    // Add Done button to Picker View
    func createToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ExchangeRateVC.endEditing))
        
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        fromLanguageTextView.inputAccessoryView = toolbar
        toLanguageTextView.inputAccessoryView = toolbar
    }
    
    // MARK: - Methods
    
    // Retrieve languages list
    private func getLanguages() {
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
    
    private func translate() {
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
    
    // Done button tapped, save languages selection
    @objc func endEditing() {
        view.endEditing(true)
        if let fromLanguage = fromLanguageTextView.text {
            translationService.fromLanguage.code = translationService.languageCode(languageName: fromLanguage)
            translationService.fromLanguage.name = fromLanguage
        }
        if let toLanguage = toLanguageTextView.text {
            translationService.toLanguage.code = translationService.languageCode(languageName: toLanguage)
            translationService.toLanguage.name = toLanguage
        }
    }
    
    func swapLanguages() {
        translationService.swapLanguages()
        
        let toLanguage = fromLanguageTextView.text
        fromLanguageTextView.text = toLanguageTextView.text
        toLanguageTextView.text = toLanguage
        
        let toText = fromTextView.text
        fromTextView.text = toTextView.text
        toTextView.text = toText
    }
    
    // MARK: - Actions
    
    @IBAction func translateButtonTapped(_ sender: UIButton) {
        translate()
    }
    
    // Abort Picker View selection
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        fromTextView.resignFirstResponder()
        toTextView.resignFirstResponder()
        // Reset display
        fromLanguageTextView.text = translationService.fromLanguage.name
        toLanguageTextView.text = translationService.toLanguage.name
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        translateButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }
    
    // Invert languages
    @IBAction func swapLanguagesButtonTapped(_ sender: UIButton) {
        swapLanguages()
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
        
        if pickerView == fromLanguagePickerView {
            fromLanguageTextView.text = currency
        } else if pickerView == toLanguagePickerView {
            toLanguageTextView.text = currency
        }
    }
}
