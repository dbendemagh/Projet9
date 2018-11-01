//
//  ExchangeRateVC.swift
//  LeBaluchon
//
//  Created by Daniel BENDEMAGH on 19/09/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class ExchangeRateVC: UIViewController {
    
    @IBOutlet weak var ConversionLabel: UILabel!
    @IBOutlet weak var fromValueTextView: UITextField!
    @IBOutlet weak var fromCurrencyTextView: UITextField!
    @IBOutlet weak var toValueTextView: UITextField!
    @IBOutlet weak var toCurrencyTextView: UITextField!
    @IBOutlet weak var currenciesPickerView: UIPickerView!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var fromEuroLabel: UILabel!
    @IBOutlet weak var toEuroLabel: UILabel!
    
    //private let apiService = APIService()
    public var currencyService = CurrencyService()
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    var originalCurrency: String = ""
    var conversionCurrency: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrencySymbols()
        getLastExchangeRate()
        
        //originalValueTextView.inputView = currenciesPickerView
        //originalCurrencyButton.inputView = currenciesPickerView
        currencyService.currentToCurrency = "USD"
    }
    
    @IBAction func convertButtonTapped(_ sender: UIButton) {
        convert()
    }
    
    func getCurrencySymbols() {
        let request = currencyService.createFixerRequest(endPoint: URLFixer.currencies)
        
        toggleActivityIndicator(shown: true)
        currencyService.get(request: request) { (success, currencyName: CurrencyName?) in
            self.toggleActivityIndicator(shown: false)
            if success, let currencyName = currencyName?.symbols {
                self.currencyService.currencies = currencyName
            } else {
                // Alert
                print("Cannot load currency symbols")
            }
        }
    }
    
    func getLastExchangeRate() {
        currencyService.currentExchangeRate = 0
        
        let request = currencyService.createFixerRequest(endPoint: URLFixer.rates, currency: "USD")
        
        toggleActivityIndicator(shown: true)
        currencyService.get(request: request) { (success, exchangeRate: ExchangeRate?) in
            self.toggleActivityIndicator(shown: false)
            if success, let exchangeRate = exchangeRate {
                if let currentExchangeRate = exchangeRate.rates["USD"] {
                    self.currencyService.currentExchangeRate = currentExchangeRate
                    self.updateDisplay()
                }
            } else {
                // Alert
            }
        }
    }
    
    func convert() {
        guard let fromValueText = fromValueTextView.text else {
            // Alert null
            return
        }
        
        guard let fromValue = Double(fromValueText) else {
            // Alert
            return
        }
        
        guard let toCurrency = toCurrencyTextView.text else {
            return
        }
        
        // Calculate with the last exchange rate
        let request = currencyService.createFixerRequest(endPoint: URLFixer.rates, currency: toCurrency)
        
        getLastExchangeRate()
        toggleActivityIndicator(shown: true)
        currencyService.get(request: request) { (success, exchangeRate: ExchangeRate?) in
            self.toggleActivityIndicator(shown: false)
            if success, let exchangeRate = exchangeRate {
                if let currentExchangeRate = exchangeRate.rates[toCurrency] {
                    self.currencyService.currentExchangeRate = currentExchangeRate
                    self.updateDisplay()
                    let result = fromValue * currentExchangeRate
                    self.toValueTextView.text = result.fraction2()
                }
            } else {
                // Alert
                print("erreur")
            }
        }
    }
    
    func updateDisplay() {
        ConversionLabel.text = "EUR -> USD"
        fromEuroLabel.text = "1 EUR = " + currencyService.currentExchangeRate.fraction2() + " \(toCurrencyTextView.text!)"
        let toEuro: Double = 1 / currencyService.currentExchangeRate
        toEuroLabel.text = "1 \(currencyService.currentToCurrency) = " + toEuro.fraction2() + " EUR"
    }
    
    // Hide Keyboard
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        fromValueTextView.resignFirstResponder()
        toValueTextView.resignFirstResponder()
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        convertButton.isHidden = shown
        activityIndicator.isHidden = !shown
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
        let currency = Array(currencyService.currencies)[row].key
        return currency
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currency = Array(currencyService.currencies)[row].key
        originalCurrency = currency
        fromCurrencyTextView.text = currency
        
    }
}
