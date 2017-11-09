//
//  MainViewController.swift
//  Umbrella
//
//  Created by Jon Rexeisen on 10/13/15.
//  Copyright © 2015 The Nerdery. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources


class MainViewController: UIViewController {
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentConditionsLabel: UILabel!
    @IBOutlet weak var currentWeatherBGView: UIView!
    
    @IBOutlet var currentLocationLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet var currentWeatherBottomConstraint: NSLayoutConstraint!
    @IBOutlet var currentTempHeight: NSLayoutConstraint!
    
    let disposeBag = DisposeBag()
    var zipcode = Variable<String>("")
    var totalWeather = Variable<[[HourlyWeather]]>([])
    var responseURL: Variable<URL>?
    
    var blurView: UIVisualEffectView?
    var daysHourlyWeatherArray: [[HourlyWeather]]?
 
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        weatherInfo.delegate = self
    //    collectionView.dataSource = self
        let network = RxNetworkLayer.shared

        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfHourlyData>(configureCell: { (sectionData, collectionView, indexPath, weather) -> UICollectionViewCell in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCellID", for: indexPath) as? HourlyWeatherCollectionViewCell else {
                fatalError("Unable to dequeue correct cell type for given index path.")
            }
            cell.format(with: weather)
            return cell
        }, configureSupplementaryView:  { (sectionData, collectionView, kind, indexPath) -> UICollectionReusableView in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderID", for: indexPath) as? DayHeaderView else {
                fatalError("Unable to dequeue correct header type for given index path.")
            }
            header.headerLabel.text = sectionData.sectionModels[indexPath.section].header
            return header
        })
        let observable = Observable.zip([network.todaysWeather, network.tomorrowsWeather, network.otherWeather]) { return $0 }
        
        observable
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
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
       // collectionView.reloadData()
      //  collectionView.reloadItems(at: indexPathsToUpdate)
    }
}

// MARK: - UICollectionViewDataSource
//extension MainViewController: UICollectionViewDataSource {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        print("Number of sections")
//
//        return totalWeather.value.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print("Loading number of items in section")
//        let day = totalWeather.value[section]
//        return day.count
//    }
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        UIView.animate(withDuration: 0.3) {
//            cell.transform = .identity
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCellID", for: indexPath) as! HourlyWeatherCollectionViewCell
//        let day = totalWeather.value[indexPath.section]
//        let hour = day[indexPath.item]
//        cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
//        cell.timeLabel.text = hour.timeString
//        cell.tempLabel.text = currentSettings.fahrenheight ? hour.tempF + "˚" : hour.tempC + "˚"
//        cell.tint = hour.tintColor
//        if let iconDict = weatherInfo.weatherIconDictionary[(hour.iconName)] {
//            let state = hour.tintColor != nil ? "solid" : "outline"
//            if let image = iconDict[state]?.withRenderingMode(.alwaysTemplate) {
//                cell.iconImageView.image = image
//            }
//        }
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        if kind == UICollectionElementKindSectionHeader {
//            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderID", for: indexPath) as! DayHeaderView
//            var dayString = ""
//            switch indexPath.section {
//            case 0: dayString = "Today"
//            case 1: dayString = "Tomorrow"
//            case 2: dayString = "Two Days From Now"
//            default: break
//            }
//            header.headerLabel.text = dayString
//            return header
//        }
//        return UICollectionReusableView()
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y < 0  {
//            let scrolledPastThreshold = 60 - scrollView.contentOffset.y
//            if !(UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft ||
//                UIDevice.current.orientation == UIDeviceOrientation.landscapeRight) {
//                currentLocationLabelBottomConstraint.constant = (scrolledPastThreshold) > 90 ? 5 - ((30 + scrollView.contentOffset.y) / 2) : 5
//            }
//            currentTempHeight.constant = min(scrolledPastThreshold, 90)
//            currentWeatherBottomConstraint.constant = scrollView.contentOffset.y
//            currentTempLabel.font = UIFont(name: currentTempLabel.font.fontName, size: min(scrolledPastThreshold, 90))
//            UIView.animate(withDuration: 0, animations: {
//                self.view.layoutIfNeeded()
//            })
//        }
//    }
//}

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

