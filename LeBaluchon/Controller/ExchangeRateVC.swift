//
//  ExchangeRateVC.swift
//  LeBaluchon
//
//  Created by Daniel BENDEMAGH on 19/09/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class ExchangeRateVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var languagesPickerView: UIPickerView!
    
    @IBOutlet weak var originalCurrencyTextView: UITextField!
    @IBOutlet weak var originalCurrencyButton: UIButton!
    @IBOutlet weak var currenciesPickerView: UIPickerView!
    
    private let apiService = APIService()
    private let exchangeRate = ExchangeRate()
    
    let currencies = ["Eur", "Dlr", "Aaa"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return exchangeRate.currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let currency = Array(exchangeRate.currencies)[row].key
        return currency
    }
    
    @IBAction func originalCurrencyButton(_ sender: UIButton) {
        originalCurrencyTextView.inputView = currenciesPickerView
    }
    
    @IBAction func ConvertButton(_ sender: UIButton) {
        let fixerRequest = apiService.createFixerRequest(endPoint: URLFixer.currencies)
//        apiService.get(request: fixerRequest) { (success, currencies: [Currency]) in
//            currencies.forEach({print($0)})
//        }
        apiService.get(request: fixerRequest) { (success, currencies: Currencies?) in
            if success {
                self.exchangeRate.currencies = currencies!.symbols
                
                print(currencies?.symbols.count)
                //currencies.foreach({print($0.key)})
                currencies?.symbols.forEach({ (arg0) in
                    
                    let (key, value) = arg0
                    print("\(key) \(value)")
                })
            }
        }
    }
}
