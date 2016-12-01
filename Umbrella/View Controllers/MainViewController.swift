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
    
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
        let settingsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "settingsID") as! SettingsViewController
        self.definesPresentationContext = true
        self.modalPresentationStyle = .currentContext
        settingsViewController.delegate = self
        
        settingsViewController.modalPresentationStyle = .overCurrentContext
        settingsViewController.popoverPresentationController?.delegate = self
        settingsViewController.popoverPresentationController?.sourceRect = sender.frame
        settingsViewController.popoverPresentationController?.sourceView = sender
        settingsViewController.popoverPresentationController?.canOverlapSourceViewRect = true
        settingsViewController.preferredContentSize = view.frame.size
        
        self.present(settingsViewController, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        // Set the popover presentation style delegate to always force a popover
        
        
        //I found that when forcing the segue to be a popover using the presentation style delegate, the subviews beneath popover were removed, leaving a generally uninteresting and blank area beneath the blurred background of the settings controller. Since the sample designs look like the settings view controller cover the screen, I think that a vertical modal presentation is appropriate - and also the only modal presentation style that supports being presented over the current context.
    }
}

extension MainViewController: SettingsViewControllerDelegate {
    func preferredTemperatureStyleChanged() {
        let currentTemp = currentSettings.fahrenheight ? weatherInfo.currentWeather?.tempF : weatherInfo.currentWeather?.tempC
        currentTempLabel.text = "\(currentTemp!)˚"
        collectionView.reloadData()
    }
}

extension MainViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
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
    
    func receivedIcon(name: String, solid: Bool) {
        var indexPathsToUpdate: [IndexPath] = []
        guard daysHourlyWeatherArray != nil else { return }
        for section in 0 ..< daysHourlyWeatherArray!.count {
            for item in 0 ..< daysHourlyWeatherArray![section].count {
                let hour = daysHourlyWeatherArray![section][item]
                if hour.iconName == name && (hour.tintColor != nil) == solid {
                    let indexPath = IndexPath(item: item, section: section)
                    indexPathsToUpdate.append(indexPath)
                }
            }
        }
        collectionView.reloadItems(at: indexPathsToUpdate)
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
        cell.tempLabel.text = currentSettings.fahrenheight ? hour!.tempF + "˚" : hour!.tempC + "˚"
        cell.tint = hour?.tintColor
        
        if let iconDict = weatherInfo.weatherIconDictionary[(hour?.iconName)!] {
            let state = hour?.tintColor != nil ? "solid" : "outline"
            if let image = iconDict[state]?.withRenderingMode(.alwaysTemplate) {
                cell.iconImageView.image = image
                let tintColor = cell.tint != nil ? UIColor(cell.tint!) : .black
                cell.iconImageView.tintColor = tintColor
            }
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderID", for: indexPath) as! DayHeaderView
            var dayString = ""
            switch indexPath.section {
            case 0: dayString = "Today"
            case 1: dayString = "Tomorrow"
            case 2: dayString = "Two Days From Now"
            default: break
            }
            header.headerLabel.text = dayString
            return header
        }
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

