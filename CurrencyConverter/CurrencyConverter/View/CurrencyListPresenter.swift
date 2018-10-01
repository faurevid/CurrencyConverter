//
//  CurrencyListPresenter.swift
//  CurrencyConverter
//
//  Created by FAURE-VIDAL Laurene  on 30/09/2018.
//  Copyright © 2018 FAURE-VIDAL Laurene. All rights reserved.
//

import Foundation
import UIKit

class CurrencyListPresenter{
    weak var view: CurrencyListViewControllerProtocol?
    let dataManager = DataManager()
    var currencyList = [RateData]()
    var currentCurrency: RateData
    var myTimer: Timer!
    var newCurrency = true
    
    init(view: CurrencyListViewControllerProtocol){
        self.view = view
        //Initiates the first currency to EUR, with a rate 1.0
        currentCurrency = RateData(code: "EUR", rate: 1.0)
        dataManager.delegate = self
        
        //The timer that launches request every second
        myTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(launchRequest), userInfo: nil, repeats: true)
    }
    
    @objc func launchRequest(){
        //Check network connection
        if Reachability.isConnectedToNetwork(){
            //The request is called on the current selected currency (or the default one)
            dataManager.getCurrency(withCode: currentCurrency.code)
        }
        else{
            view?.displayNetworkError()
        }
    }
}

//MARK: Data management
extension CurrencyListPresenter: LoadingDelegate{
    func dataReceived() {
        currencyList.removeAll()
        let tmpList = (dataManager.currency?.rates)!
        for (key, value) in tmpList{
            currencyList.append(RateData(code: key, rate: value))
        }
        if newCurrency {
            view?.loadData()
            newCurrency = false
        }
        else{
            view?.reloadData()
        }
    }
    
    func dataFailed(error: Error) {
        view?.displayError(error: error)
    }
    
    
}

extension CurrencyListPresenter: CurrencyListPresenterProtocol{
    func numberOfCurrencies() -> Int {
        return currencyList.count + 1
    }
    
    func willShow(cell: CurrencyCell, atIndexPath: IndexPath) {
        if(atIndexPath.row == 0){
            cell.currencyCode.text = currentCurrency.code
            cell.currencyName.text = dataManager.getCurrencyName(fromCode: currentCurrency.code)
            cell.convertionAmount.text = String(format: "%.2f",currentCurrency.rate)
            cell.backgroundColor = UIColor.lightGray
            
        }
        else{
        let currency = currencyList[atIndexPath.row - 1]
        cell.backgroundColor = UIColor.white
        cell.currencyCode.text = currency.code
            cell.currencyName.text = dataManager.getCurrencyName(fromCode: currency.code)
        cell.convertionAmount.text = String(format: "%.2f", currency.rate * currentCurrency.rate)
        }
    }
    
    func didSelect(cell: CurrencyCell, atIndex: Int) {
        if atIndex != 0{
        currentCurrency = currencyList[atIndex - 1]
            if let amount = cell.convertionAmount.text{
                currentCurrency.rate = Double(amount)!
            }
            newCurrency = true
        launchRequest()
        }
    }
    
    func changeCurrency(rate: String) {
        currentCurrency.rate = Double(rate)!
        view?.reloadData()
    }
  
    func retryLoading() {
        launchRequest()
    }
}
