//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

//MARK: - Note 21: Create a protocol, this delegate will be notified when data is passed in and then it'll pass the data to the other view controller, make sure to set the delegate as self in that vc.
protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    //MARK: - Note 24: Makeing this into an optional will now not require other view contorllers to call or add missing arguments for parameter delegate.
    var delegate: CoinManagerDelegate?
    
    //MARK: - Note 1: let syntax can also be called constraints
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    //MARK: - Note 10: Go to coinapi.io, API Docs, REST API, Exchange Rates. Get authentication key by signing up.
    let apiKey = "3EF2BE0D-CB58-4EE4-A957-1EACCEEF0CC8"
    let urlWithKey = "https://rest.coinapi.io/v1/exchangerate/BTC/USD?apikey=3EF2BE0D-CB58-4EE4-A957-1EACCEEF0CC8"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        //MARK: - Note 11: Use String concatenation to add the selected currency at the end of the baseURL along with eht API key.
        let finalURLString = String("\(baseURL)/\(currency)?apikey=\(apiKey)")
        print(finalURLString)
        //MARK: - Note 12: Use optional binding to unwrap the URL that's created from the finalURLString.
        if let url = URL(string: finalURLString) {
            //MARK: - Note 13: Create a new URLSession object with default configurations.
            let session = URLSession(configuration: .default)
            //MARK: - Note 14: Create a new data task for the URLSession
            let task = session.dataTask(with: url) { (data, urlResponse, error) in
                if error != nil {
                    //MARK: - Note 22: Use the new delegate from the new protocol to pass errors. The delegate here has to be an optional as it may not have a value.
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                //MARK: - Note 15: Format the data we got back as a string to be able to print it.
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        //MARK: - Note 23: After getting the value back from the parseJSON function, use that double and converto it to a string.
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        //MARK: - Note 24: pass the to the another view controller via new delegate and protocol method. This also is a optional 'delegate?.'.
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
            }
            //MARK: - Note 16: Start task to fetch data from bitcoin average's servers.
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        //MARK: - Note 17: Create a JSONDecoder
        let decoder = JSONDecoder()
        do {
            //MARK: - Note 18: try to recode the data using 'CoinData' structure.
            let decodedData = try decoder.decode(CoinData.self, from: data)
            //MARK: - Note 19: Get the last, rate, property from the decoded data.
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice
            //MARK: - Note 20: Catch and print any errors, and returning a nil to a Double data type makes it an optional as optionals can only take nil values.
        } catch {
            print(error)
            return nil
        }
    }
}
