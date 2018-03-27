//
//  ViewController.swift
//  Saathi
//
//  Created by Zineb El mechrafi on 10/2/17.
//  Copyright © 2017 Zineb El mechrafi. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var language: UIPickerView!
    @IBOutlet var city: UIPickerView!
    var cities = ["NYC", "San Francisco","Boston","DC"]
    var languagesSpoken = ["Arabic","French","English","Spanish"]
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == city{
            return cities[row]
        }
        else{
            
            return languagesSpoken[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == city {
            return cities.count
        }
            
        else{
            return languagesSpoken.count
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        language.delegate = self
        language.dataSource = self
        
        city.delegate = self
        city.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
