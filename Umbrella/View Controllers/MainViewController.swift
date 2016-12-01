//
//  MainViewController.swift
//  Umbrella
//
//  Created by Jon Rexeisen on 10/13/15.
//  Copyright © 2015 The Nerdery. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentConditionsLabel: UILabel!
    
    var daysHourlyWeatherArray: [[HourlyWeather]]?
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        weatherInfo.delegate = self
        // Setup the request
        var weatherRequest = WeatherRequest(APIKey: "833018b6135efd73")
        
        // Set the zip code
        weatherRequest.zipCode = "60647"
        
        // Here's your URL. Marshall this to the internet however you please.
        let url = weatherRequest.URL
        WeatherAPIManager.sharedInstance.fetchHourlyForecast(fromURL: url!)
        


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    @IBAction func returnFromSettingsSegue(_: UIStoryboardSegue) {
        
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // Set the popover presentation style delegate to always force a popover
    }
}

//MARK: - WeatherInfoDelegate
extension MainViewController: WeatherInfoDelegate {
    func received(currentWeather: CurrentWeather) {
        let currentTemp = currentSettings.fahrenheight ? currentWeather.tempF : currentWeather.tempC
        view.backgroundColor = currentWeather.tempF > 60 ? UIColor(0xFF9800) : UIColor(0x03A9F4)
        currentTempLabel.text = "\(currentTemp)˚"
        currentLocationLabel.text = currentWeather.fullLocation
        currentConditionsLabel.text = currentWeather.conditions
    }
    
    func receivedHourlyWeather(forDays: [[HourlyWeather]]) {
        daysHourlyWeatherArray = forDays
        collectionView.reloadData()
    }
   
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return daysHourlyWeatherArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let day = daysHourlyWeatherArray?[section]
        return day?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCellID", for: indexPath) as! HourlyWeatherCollectionViewCell
        let day = daysHourlyWeatherArray?[indexPath.section]
        let hour = day?[indexPath.item]
        
        cell.timeLabel.text = hour?.timeString
        cell.tempLabel.text = currentSettings.fahrenheight ? hour?.tempF : hour?.tempC
        cell.tint = hour?.tintColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return UICollectionReusableView()
    }
}
//MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 62, height: 62)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

