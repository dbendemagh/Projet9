//
//  ExchangeRateVC.swift
//  LeBaluchon
//
//  Created by Daniel BENDEMAGH on 19/09/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class ExchangeRateVC: UIViewController {
    
    @IBOutlet weak var languagesPickerView: UIPickerView!
    
    @IBOutlet weak var originalCurrencyTextView: UITextField!
    @IBOutlet weak var originalCurrencyButton: UIButton!
    @IBOutlet weak var convertedCurrencyButton: UIButton!
    @IBOutlet weak var currenciesPickerView: UIPickerView!
    
    private let apiService = APIService()
    public let currencyService = CurrencyService()
    
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
        
        originalCurrencyTextView.inputView = currenciesPickerView
        //originalCurrencyButton.inputView = currenciesPickerView
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func originalCurrencyButton(_ sender: UIButton) {
        
        //sender.inputView = currenciesPickerView
        //originalCurrencyTextView.inputView = currenciesPickerView
    }
    
    @IBAction func convertedCurrencyBtnTapped(_ sender: UIButton) {
    }
    
    @IBAction func convertButton(_ sender: UIButton) {
        let fixerRequest = currencyService.createFixerRequest(endPoint: URLFixer.currencies)

        apiService.get(request: fixerRequest) { (success, currencyName: CurrencyName?) in
            if success {
                if let currencySymbols = currencyName?.symbols {
                    self.currencyService.currencies = currencySymbols
                    
                    //print(currency?.symbols.count)
                    //currencies.foreach({print($0.key)})
                    currencyName?.symbols.forEach({ (arg0) in
                        let (key, value) = arg0
                        print("\(key) \(value)")
                    })
                }
            }
        }
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
        originalCurrencyButton.setTitle(currency, for: .normal)
        
    }
}
