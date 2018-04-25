//
//  WeatherVC.swift
//  NavSail
//
//  Created by Bora Dincer on 4/21/18.
//  Copyright © 2018 Bora Dincer. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class WeatherVC: UIViewController {
    
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    
    //Constants
    let WEATHER_URL = "https://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "dad2865a9d80b2424078ef83a7b7fb1e"  //"e72ca729af228beabd5d20e3b7749713"
    let unit = "imperial"
    
    
    //Instant Variables
    let weatherDataModel = WeatherDataModel()
    var lat: Double = 0.00
    var long: Double = 0.00
    
    var currentLocation : CurrentLocation? {
        didSet{
            setLocation()
        }
    }
    
    func setLocation(){
        print ("setlocation called")
       
        if lat != 0.00 {
            let latStr = String(lat)
            let longStr = String(long)
            
            let  param = ["lat": latStr, "lon": longStr, "appid" : APP_ID, "units" : unit]
            getWeatherData(url: WEATHER_URL, parameters: param)
        }
        
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        
         self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
   
        setLocation()
        // Do any additional setup after loading the view.
    }

    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    func getWeatherData(url:String, parameters: [String: String]){
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess{
                print("success: Got the weather data")
                let weatherJSON: JSON = JSON(response.result.value!)
                print("JSON: \(weatherJSON)")
                self.updateWeatherData(json: weatherJSON)
                
            }
            else {
                print("Error: \(response.result.error!)")
                self.cityName.text = "Connection Issues"
            }
        }
    }

    //Write the updateWeatherData method here:
    func updateWeatherData (json :JSON){
        
        
        if let tempResults = json["main"]["temp"].double {
            weatherDataModel.temperature = Int(tempResults) // - 273.15)
            weatherDataModel.city =  json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.description = json["weather"][0]["description"].stringValue
            weatherDataModel.wind = json["wind"]["speed"].doubleValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            weatherDataModel.degreeText =  weatherDataModel.directionWind(wind: json["wind"]["deg"].intValue)
            
            updateUIWithWeatherData()
            
            
        }
        else {
            cityName.text = "Weather unavailable"
        }
    }

    func updateUIWithWeatherData(){
        
        cityName.text = weatherDataModel.city
        tempLabel.text = "\(weatherDataModel.temperature)°"
        weatherImage.image = UIImage(named: weatherDataModel.weatherIconName)
        windLabel.text = "\(weatherDataModel.wind) mph " + weatherDataModel.degreeText
    }
   
}
