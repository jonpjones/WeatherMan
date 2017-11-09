//
//  MainViewController.swift
//  Umbrella
//
//  Created by Jon Rexeisen on 10/13/15.
//  Copyright © 2015 The Nerdery. All rights reserved.
//

import UIKit
let apiKey = "833018b6135efd73"
class MainViewController: UIViewController {
    
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentConditionsLabel: UILabel!
    @IBOutlet weak var currentWeatherBGView: UIView!
    
    @IBOutlet var currentLocationLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet var currentWeatherBottomConstraint: NSLayoutConstraint!
    @IBOutlet var currentTempHeight: NSLayoutConstraint!
    
    var blurView: UIVisualEffectView?
    var daysHourlyWeatherArray: [[HourlyWeather]]?
    let transition = TableViewTransitioner()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherInfo.delegate = self
//        var weatherRequest = WeatherRequest(APIKey: apiKey)
//        weatherRequest.zipCode = currentSettings.zip
//        let url = weatherRequest.URL
//        WeatherAPIManager.sharedInstance.fetchHourlyForecast(fromURL: url!) { (success) in
//            guard success else {
//                self.presentErrorAlert()
//                return
//            }
//        }
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            currentLocationLabel.textAlignment = .center
        } else {
            currentLocationLabel.textAlignment = .left
        }
    }
    
    // MARK: - Navigation
    
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
        blurView = UIVisualEffectView(frame: self.view.frame)
        
        popOverToSettings(source: sender)
    }
    
    func popOverToSettings(source: UIView) {
        let settingsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "settingsID") as! SettingsViewController
        self.definesPresentationContext = true
        self.modalPresentationStyle = .currentContext
        settingsViewController.delegate = self
        
        settingsViewController.modalPresentationStyle = .overCurrentContext
        settingsViewController.popoverPresentationController?.delegate = self
        settingsViewController.popoverPresentationController?.sourceRect = source.frame
        settingsViewController.popoverPresentationController?.sourceView = source
        settingsViewController.popoverPresentationController?.canOverlapSourceViewRect = true
        settingsViewController.preferredContentSize = view.frame.size
        self.present(settingsViewController, animated: true, completion: nil)
    }
}

extension MainViewController: SettingsViewControllerDelegate {
    func preferredTemperatureStyleChanged() {
        let currentTemp = currentSettings.fahrenheight ? weatherInfo.currentWeather?.tempF : weatherInfo.currentWeather?.tempC
        
        currentTempLabel.text = "\(currentTemp ?? 0)˚"
       // collectionView.reloadData()
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
        currentWeatherBGView.backgroundColor = currentWeather.tempF > 60 ? UIColor(0xFF9800) : UIColor(0x03A9F4)
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
        collectionView.reloadData()
      //  collectionView.reloadItems(at: indexPathsToUpdate)
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
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            cell.transform = .identity
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCellID", for: indexPath) as! HourlyWeatherCollectionViewCell
        let day = daysHourlyWeatherArray?[indexPath.section]
        let hour = day?[indexPath.item]
        cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        cell.timeLabel.text = hour?.timeString
        cell.tempLabel.text = currentSettings.fahrenheight ? hour!.tempF + "˚" : hour!.tempC + "˚"
        cell.tint = hour?.tintColor
        
        if let iconDict = weatherInfo.weatherIconDictionary[(hour?.iconName)!] {
            let state = hour?.tintColor != nil ? "solid" : "outline"
            if let image = iconDict[state]?.withRenderingMode(.alwaysTemplate) {
                cell.iconImageView.image = image
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0  {
            let scrolledPastThreshold = 60 - scrollView.contentOffset.y
            if !(UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft ||
                UIDevice.current.orientation == UIDeviceOrientation.landscapeRight) {
                currentLocationLabelBottomConstraint.constant = (scrolledPastThreshold) > 90 ? 5 - ((30 + scrollView.contentOffset.y) / 2) : 5
            }
            currentTempHeight.constant = min(scrolledPastThreshold, 90)
            currentWeatherBottomConstraint.constant = scrollView.contentOffset.y
            currentTempLabel.font = UIFont(name: currentTempLabel.font.fontName, size: min(scrolledPastThreshold, 90))
            UIView.animate(withDuration: 0, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? HourlyWeatherCollectionViewCell
            else {
                return
        }
        cell.jiggle()
        
        if let sampleVC = storyboard?.instantiateViewController(withIdentifier: "SampleVC") as? SampleViewController {
            sampleVC.sourceFrame = cell.superview?.convert(cell.frame, to: nil)
            sampleVC.transitioningDelegate = self
            transition.sourceRect = cell.superview!.convert(cell.frame, to: nil)
            present(sampleVC, animated: true, completion: nil)
        }
    }
}

extension MainViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
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

