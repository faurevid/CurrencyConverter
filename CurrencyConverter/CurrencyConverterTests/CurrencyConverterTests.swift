//
//  CurrencyConverterTests.swift
//  CurrencyConverterTests
//
//  Created by FAURE-VIDAL Laurene  on 30/09/2018.
//  Copyright © 2018 FAURE-VIDAL Laurene. All rights reserved.
//

import XCTest
@testable import CurrencyConverter

class CurrencyConverterTests: XCTestCase {
    
    var dm: DataManager!
    
    override func setUp() {
        super.setUp()
        
        dm = DataManager()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetCurrency() {
    dm.getCurrency(withCode: "EUR")
        sleep(5)
        XCTAssertTrue(dm.currency != nil)
    }
    
    func testGetCurrencyName(){
        XCTAssertEqual(dm.getCurrencyName(fromCode: "EUR"), "Euro")
    }
    
}
