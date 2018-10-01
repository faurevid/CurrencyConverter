//
//  CurrencyListProtocol.swift
//  CurrencyConverter
//
//  Created by FAURE-VIDAL Laurene  on 30/09/2018.
//  Copyright © 2018 FAURE-VIDAL Laurene. All rights reserved.
//

import Foundation
import UIKit

protocol CurrencyListViewControllerProtocol: class {
    func loadData()
    func reloadData()
    func displayError(error: Error)
    func displayNetworkError()
}

protocol CurrencyListPresenterProtocol: class {
    func numberOfCurrencies() -> Int
    func willShow(cell: CurrencyCell, atIndexPath: IndexPath)
    func didSelect(cell: CurrencyCell, atIndex: Int)
    func changeCurrency(rate: String)
    func retryLoading()
}

protocol LoadingDelegate {
    func dataReceived()
    func dataFailed(error: Error)
}
