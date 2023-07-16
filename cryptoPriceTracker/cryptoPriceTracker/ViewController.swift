//
//  ViewController.swift
//  cryptoPriceTracker
//
//  Created by russell gadsden on 7/16/23.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var price: UILabel!
    
    
    var crpCcy: [String] = [];
    var ccy: [String] = [];

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Crypto & Currency"
        crpCcy = ["BTC", "ETH", "XRP", "BCH"]
        ccy = ["USD", "EUR", "JPY", "CHF"]
    
        self.picker.delegate = self
        self.picker.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (component == 0){
            return crpCcy.count;
        } else {
            return ccy.count;
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (component == 0) {
            return crpCcy[row];
        }
        else {
            return ccy[row];
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        getPrice(crpCcy: crpCcy[picker.selectedRow(inComponent: 0)], ccy: ccy[picker.selectedRow(inComponent: 1)])
    }
   
    func getPrice(crpCcy: String, ccy: String) {
        if let url = URL(string: "https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=USD,JPY,EU" + crpCcy + "&tsysms=" + ccy){
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Double] {
                        DispatchQueue.main.async {
                            if let price = json[ccy] {
                                let formatter = NumberFormatter()
                                formatter.currencyCode = ccy
                                formatter.numberStyle = .currency
                                let formattedPrice = formatter.string(from: NSNumber(value: price))
                                self.price.text = "\(price)"
                            }
                        }
                    }
                }
                else {
                    print("Wrong = (")
                }
            }.resume()
        }
    }

}

