//
//  WeatherDataModel.swift
//  NavSail
//
//  Created by Bora Dincer on 4/23/18.
//  Copyright © 2018 Bora Dincer. All rights reserved.
//

import Foundation
class WeatherDataModel {
    
    //Declare your model variables here
    var temperature : Int = 0
    var condition : Int = 0
    var city : String = ""
    var weatherIconName : String = ""
    var wind : Double = 0.00
    var description: String = ""
    var degreeText: String = ""
    
    
    //Wind Direction
    func directionWind(wind: Int) -> String {
     
        let array = ["N","NNE","NE","ENE","E","ESE", "SE", "SSE","S","SSW","SW","WSW","W","WNW","NW","NNW"]
        let val = Int( (Double(wind) / 22.5) + 0.5)
        
        print("val: \(val)")
        return ("\(array[(val % 16)])")
        
    }
    
    //This method turns a condition code into the name of the weather condition image
    func updateWeatherIcon(condition: Int) -> String {
        
        switch (condition) {
            
        case 0...300 :
            return "tstorm1"
            
        case 301...500 :
            return "light_rain"
            
        case 501...600 :
            return "shower3"
            
        case 601...700 :
            return "snow4"
            
        case 701...771 :
            return "fog"
            
        case 772...799 :
            return "tstorm3"
            
        case 800 :
            return "sunny"
            
        case 801...804 :
            return "cloudy2"
            
        case 900...903, 905...1000  :
            return "tstorm3"
            
        case 903 :
            return "snow5"
            
        case 904 :
            return "sunny"
            
        default :
            return "dunno"
        }
        
    }
}
