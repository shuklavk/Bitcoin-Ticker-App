//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//  Improved by Vikas Shukla on 06/26/2019
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""
    var rowNumber = 0;

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
       
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(currencyArray[row])
        rowNumber = row
        finalURL = baseURL + currencyArray[row]
        getBitCoinData(url: finalURL)
    }
    
    
    
//    
//    //MARK: - Networking
//    /***************************************************************/
//
    func getBitCoinData(url: String){
        
        Alamofire.request(url, method: .get)
            .responseJSON{ response in
                if response.result.isSuccess{
                    print("Success! You got bitcoin data!")
                    
                    let bitcoinJSON : JSON = JSON(response.result.value!)
                    
                    self.updateBitcoinData(json: bitcoinJSON)
                }else{
                    print("Error: \(response.result.error)")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
        }
    }
//    
//    
//    
//    
//    //MARK: - JSON Parsing
//    /***************************************************************/
//
    func updateBitcoinData(json:JSON){
        
        if let bitcoinValue = json["ask"].double{
            print(bitcoinValue)
            bitcoinPriceLabel.text = "\(currencySymbolArray[rowNumber]) \(bitcoinValue)"
        }else{
            bitcoinPriceLabel.text = "Bitcoin Unavailable"
        }
    }

}

