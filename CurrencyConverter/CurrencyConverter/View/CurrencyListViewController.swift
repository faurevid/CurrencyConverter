//
//  CurrencyListViewController.swift
//  CurrencyConverter
//
//  Created by FAURE-VIDAL Laurene  on 30/09/2018.
//  Copyright © 2018 FAURE-VIDAL Laurene. All rights reserved.
//

import Foundation
import UIKit

class CurrencyListViewController: UIViewController{
    @IBOutlet weak var currencyTableView: UITableView!
    weak var presenter: CurrencyListPresenterProtocol?
    var currentFirstResponder: UITextField?
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = CurrencyListPresenter(view: self)
    }
}
//MARK: CurrencyListViewControllerProtocol
extension CurrencyListViewController: CurrencyListViewControllerProtocol{
    
    //Called when a new currency is selected
    //Reloads all tableView
    func loadData(){
        currencyTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
           currencyTableView.reloadData()
    }
    
    //Called at each refresh
    //Reloads all cells but the first one
    func reloadData() {
        guard let numberOfCurrencies = presenter?.numberOfCurrencies() else {
            return
        }
        var allIndexPaths = [IndexPath]()
        for i in 1...numberOfCurrencies - 1{
            allIndexPaths.append(IndexPath(row: i, section: 0))
        }
        currencyTableView.reloadRows(at: allIndexPaths, with: .fade)
        openKeyboardOnFirstCell()
      
    }
    
    //Opens keyboard on first cell if it is visible
    private func openKeyboardOnFirstCell(){
        guard let current = currencyTableView.cellForRow(at: IndexPath(row: 0, section: 0)) else {
            return
        }
        self.currentFirstResponder = (currencyTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! CurrencyCell).convertionAmount
        self.currentFirstResponder?.isUserInteractionEnabled = true
        self.currentFirstResponder?.becomeFirstResponder()
    }
    
    //MARK: Error handling
    func displayError(error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Try again", style: .default, handler: {(alert: UIAlertAction!) in self.presenter?.retryLoading()})
        alertController.addAction(action)
        
        self.present(alertController, animated: true)
    }
    
    func displayNetworkError() {
        let alertController = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Try again", style: .default, handler: {(alert: UIAlertAction!) in self.presenter?.retryLoading()})
        alertController.addAction(action)
        
        self.present(alertController, animated: true)
    }
}

//MARK: TableView Management
extension CurrencyListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (presenter?.numberOfCurrencies())!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as? CurrencyCell else{
            return UITableViewCell()
        }
        presenter?.willShow(cell: cell, atIndexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
        presenter?.didSelect(cell: cell as! CurrencyCell, atIndex: indexPath.row)
        
    }
    
    //Opens keyboard when scroll to top
    //Closes keyboard when scroll down
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 1{
            openKeyboardOnFirstCell()
            return
        }
        if let currentFirstResponder = currentFirstResponder{
            if currentFirstResponder.isFirstResponder{
                currentFirstResponder.resignFirstResponder()
            }
        }
    }
}

//MARK: UITextFieldDelegate
extension CurrencyListViewController : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newString = string
        if string == "," {
            if (textField.text?.contains("."))! || (textField.text?.contains(","))! || textField.text == ""{
                //Can't add another "," to a double
                return false
            }
            else {
                newString = "."
            }
        }
        if let textFieldString = textField.text, let swtRange = Range(range, in: textFieldString) {
            
            var fullString = textFieldString.replacingCharacters(in: swtRange, with: newString)
            
            if newString == "" && (fullString.last == "," || fullString.last == "."){
                fullString.removeLast()
            }
            if fullString == "" {
                fullString = "0"
            }
            presenter?.changeCurrency(rate: fullString.replacingOccurrences(of: ",", with: "."))
        }
        
        return true
    }
}
