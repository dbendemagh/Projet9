//
//  CurrencyTextField.swift
//  LeBaluchon
//
//  Created by Daniel BENDEMAGH on 17/11/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class CurrencyTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        layer.cornerRadius = 5
    }
}
