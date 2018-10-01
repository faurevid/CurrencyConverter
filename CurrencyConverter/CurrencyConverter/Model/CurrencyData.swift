//
//  CurrencyData.swift
//  CurrencyConverter
//
//  Created by FAURE-VIDAL Laurene  on 30/09/2018.
//  Copyright © 2018 FAURE-VIDAL Laurene. All rights reserved.
//

import Foundation

struct CurrencyData: Decodable{
    let base: String
    let date: String
    let rates: [String: Double]
}


struct RateData {
    var code: String
    var rate: Double
}
