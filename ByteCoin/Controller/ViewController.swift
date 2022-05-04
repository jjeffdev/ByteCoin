//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

//MARK: - Note 2: at the class declaration, add UIPickerViewDataSource.
//MARK: - Note 25: Adopt the coinManagerDelegate protocol.
class ViewController: UIViewController, UIPickerViewDataSource, CoinManagerDelegate {

    
    
    //MARK: - Note 26: Now this will have to become a var as its mutable with the passing of updated data.
    var coinManager = CoinManager()
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Note 3: set this view controller as the data source for the picker. So, where is the data populating and then its dataSource property to self? self is the view or current view controller. setting a value to self is setting the current call and property to current view (controller).
        currencyPicker.dataSource = self
        //MARK: - Note 7: Set this view controller as the delegate for currencyPicker.
        currencyPicker.delegate = self
        //MARK: - Note 27: Remeber to always call the delegate as self in this view controller.
        coinManager.delegate = self
    }
    
    //MARK: - Note 28: Provide the implementation for the new delegate methods. When the coinManager gets the price it will call this method and pass over the price and currency.
    func didUpdatePrice(price: String, currency: String) {
        
        //MARK: - Note 29: Remember to get ahold of the main thread whenever we update the UI, otherwise our app will crash if this is done in the background (URLSession works in the background).
        DispatchQueue.main.async {
            self.bitcoinLabel.text = price
            self.currencyLabel.text = currency
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
//MARK: - Picker View Data Source
    //MARK: - Note 4: How many columns do we want in our picker. The number of components (or “columns”) that the picker view should display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //MARK: - Note 5: How many rows do we want in this picker. Make a new property or constraint and man an object to call CoinManager.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
}

//MARK: - Picker View Delegate Methods
//MARK: - Note 6: add UIPickerViewDelegate to this classes declaration. To do it alternatively, create an extension, call this view controller then add the delegate class declaration.
extension ViewController: UIPickerViewDelegate {
    
    //MARK: - Note 8: Add the pickerView delegate method. This expects a string to return as the title. This method will act as the delegate for a row title and call this method once for every row. This will iterate through the arrary in coinManager and for every item it will be added in the scroll wheel.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    //MARK: - Note 9: add a new delegate method to do something when a selection is made from the titleFOrROw, 'didSelectRow'. Print the current row number to test it, 'print(row)'. To print the name or value of the current row selected call, 'coinManager.currencyArray[row]'. Make a property or constraint to hold this value so not to copy multiple times, succinct.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
}
