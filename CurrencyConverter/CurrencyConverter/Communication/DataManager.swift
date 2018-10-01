//
//  DataManager.swift
//  CurrencyConverter
//
//  Created by FAURE-VIDAL Laurene  on 30/09/2018.
//  Copyright © 2018 FAURE-VIDAL Laurene. All rights reserved.
//

import Foundation


class DataManager {
var currency : CurrencyData?
var delegate: LoadingDelegate?
static let urlString = "https://revolut.duckdns.org/latest?base=%@"

    func getCurrency(withCode: String) {
    guard let url = URL(string: String(format:DataManager.urlString, withCode)) else { return }
    
    URLSession.shared.dataTask(with: url) { (data, response, err) in
        guard let data = data else { return }
        do{
            let currency = try JSONDecoder().decode(CurrencyData.self, from: data)
            self.currency = currency
            
            DispatchQueue.main.async {
                self.delegate?.dataReceived()
            }
        }
        catch let jsonError {
            print("Error serializing json", jsonError)
            self.delegate?.dataFailed(error: jsonError)
        }
        }.resume()
}
    
   func getCurrencyName(fromCode: String) -> String{
    if let path = Bundle.main.path(forResource: "Currencies", ofType: "plist"),
        let myDict = NSDictionary(contentsOfFile: path){
        guard let value = myDict.value(forKey: fromCode) else{
            return ""
        }
        return value as! String
    }
    return ""
    }
}
