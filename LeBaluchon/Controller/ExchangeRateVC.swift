//
//  ExchangeRateVC.swift
//  LeBaluchon
//
//  Created by Daniel BENDEMAGH on 19/09/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class ExchangeRateVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var fromCurrencyCodeLabel: UILabel!
    @IBOutlet weak var toCurrencyCodeLabel: UILabel!
    @IBOutlet weak var fromValueTextField: UITextField!
    @IBOutlet weak var fromCurrencyCodeTextField: UITextField!
    @IBOutlet weak var toValueTextField: UITextField!
    @IBOutlet weak var toCurrencyCodeTextField: UITextField!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var fromUnitConversionLabel: UILabel!
    @IBOutlet weak var toUnitConversionLabel: UILabel!
    @IBOutlet weak var fromCurrencyNameLabel: UILabel!
    @IBOutlet weak var toCurrencyNameLabel: UILabel!
    
    // MARK: - Properties
    
    public var currencyService = CurrencyService()
    
    // Pickers for currency selection
    lazy var fromCurrencyPicker: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    lazy var toCurrencyPicker: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    // MARK: - Init Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrencySymbols()
        getLastExchangeRate()
        
        setupCurrenciesPicker()
        createToolbar()
    }
    
    // Picker View for currency choice
    private func setupCurrenciesPicker() {
        fromCurrencyCodeTextField.inputView = fromCurrencyPicker
        toCurrencyCodeTextField.inputView = toCurrencyPicker
    }
    
    // Add Done button to picker View
    private func createToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ExchangeRateVC.endEditing))
        
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        fromCurrencyCodeTextField.inputAccessoryView = toolbar
        toCurrencyCodeTextField.inputAccessoryView = toolbar
    }
    
    // MARK: - Methods
    
    // Retrieve currency list for Picker View selection
    private func getCurrencySymbols() {
        if let request = currencyService.createFixerRequest(endPoint: URLFixer.currencies) {
            toggleActivityIndicator(shown: true)
            currencyService.get(request: request) { (success, currencyName: CurrencyName?) in
                self.toggleActivityIndicator(shown: false)
                if success, let currencyName = currencyName?.symbols {
                    // Convert dictionnary to Currency struct and sort by name
                    self.currencyService.currencies = currencyName.map({return Currency(code: $0.key, name: $0.value) }).sorted(by: {$0.name < $1.name})
                    print(self.currencyService.currencies)
                    self.updateDisplay()
                } else {
                    self.displayAlert(title: "Network error", message: "Cannot retrieve currency symbols")
                }
            }
        }
    }
    
    // Retrieve last Exchange rate
    private func getLastExchangeRate() {
        currencyService.fromExchangeRate = 0
        currencyService.toExchangeRate = 0
        
        if let request = currencyService.createFixerRequest(endPoint: URLFixer.rates, currencyConversion: true) {
        
            toggleActivityIndicator(shown: true)
            currencyService.get(request: request) { (success, exchangeRate: ExchangeRate?) in
                self.toggleActivityIndicator(shown: false)
                if success, let exchangeRate = exchangeRate {
                    self.currencyService.exchangeRates = exchangeRate.rates
                    if let fromExchangeRate = exchangeRate.rates[self.currencyService.fromCurrency],
                        let toExchangeRate = exchangeRate.rates[self.currencyService.toCurrency] {
                        self.currencyService.fromExchangeRate = fromExchangeRate
                        self.currencyService.toExchangeRate = toExchangeRate
                        self.updateDisplay()
                    }
                } else {
                    self.displayAlert(title: "Network error", message: "Cannot retrieve exchange rate")
                }
            }
        }
    }
    
    private func convert() {
        guard let fromValueText = fromValueTextField.text, fromValueTextField.text != "" else {
            self.displayAlert(title: "No entry", message: "Enter a value to convert")
            return
        }
        
        guard let fromValue = Double(fromValueText) else {
            self.displayAlert(title: "Incorrect value", message: "Enter a valid value to convert")
            return
        }
        
        // Calculate with the last exchange rate
        if let request = currencyService.createFixerRequest(endPoint: URLFixer.rates, currencyConversion: true) {
        
            toggleActivityIndicator(shown: true)
            currencyService.get(request: request) { (success, exchangeRate: ExchangeRate?) in
                self.toggleActivityIndicator(shown: false)
                if success, let exchangeRate = exchangeRate {
                    if let fromExchangeRate = exchangeRate.rates[self.currencyService.fromCurrency],
                        let toExchangeRate = exchangeRate.rates[self.currencyService.toCurrency] {
                        self.currencyService.fromExchangeRate = fromExchangeRate
                        self.currencyService.toExchangeRate = toExchangeRate
                        self.updateDisplay()
                        let result = fromValue * self.currencyService.exchangeRate
                        self.toValueTextField.text = result.fraction(2)
                    }
                } else {
                    self.displayAlert(title: "Network error", message: "Cannot retrieve exchange rate")
                }
            }
        }
    }
    
    private func updateDisplay() {
        fromCurrencyCodeLabel.text = currencyService.fromCurrency
        toCurrencyCodeLabel.text = currencyService.toCurrency
        
        fromCurrencyNameLabel.text = currencyService.currencyName(code: currencyService.fromCurrency)
        toCurrencyNameLabel.text = currencyService.currencyName(code: currencyService.toCurrency)
        
        fromUnitConversionLabel.text = "1 \(currencyService.fromCurrency) = \(currencyService.exchangeRate.fraction(6)) \(currencyService.toCurrency)"
        let toValue: Double = 1 / currencyService.exchangeRate
        toUnitConversionLabel.text = "1 \(currencyService.toCurrency) = \(toValue.fraction(6)) \(currencyService.fromCurrency)"
    }
    
    @objc func endEditing() {
        view.endEditing(true)
        if let fromCurrency = fromCurrencyCodeTextField.text {
            currencyService.fromCurrency = fromCurrency
        }
        if let toCurrency = toCurrencyCodeTextField.text {
            currencyService.toCurrency = toCurrency
        }
        toValueTextField.text = ""
        getLastExchangeRate()
        
        updateDisplay()
    }
    
    // display Activity indicator
    private func toggleActivityIndicator(shown: Bool) {
        convertButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }
    
    private func swapCurrencies() {
        currencyService.swapCurrencies()
        
        let toValue = fromValueTextField.text
        
        fromValueTextField.text = toValueTextField.text
        toValueTextField.text = toValue
        
        fromCurrencyCodeTextField.text = currencyService.fromCurrency
        toCurrencyCodeTextField.text = currencyService.toCurrency
        
        updateDisplay()
    }
    
    // MARK: - Actions
    
    @IBAction func convertButtonTapped(_ sender: UIButton) {
        convert()
    }
    
    // Hide Picker View
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        fromValueTextField.resignFirstResponder()
        toValueTextField.resignFirstResponder()
        // Reset display
        fromCurrencyCodeTextField.text = currencyService.fromCurrency
        toCurrencyCodeTextField.text = currencyService.toCurrency
    }
    
    // Invert currencies
    @IBAction func currenciesButtonTapped(_ sender: UIButton) {
        swapCurrencies()
    }
}

extension ExchangeRateVC: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return  currencyService.currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let currency = currencyService.currencies[row].name
        return currency
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currency = currencyService.currencies[row].code
        //originalCurrency = currency
        
        if pickerView == fromCurrencyPicker {
            fromCurrencyCodeTextField.text = currency
        } else if pickerView == toCurrencyPicker {
            toCurrencyCodeTextField.text = currency
        }
    }
}
