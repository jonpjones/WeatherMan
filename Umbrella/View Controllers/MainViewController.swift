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
    @IBOutlet weak var currentWeatherBGView: CurrentWeatherview!
    
    @IBOutlet var currentLocationLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet var currentWeatherBottomConstraint: NSLayoutConstraint!
    @IBOutlet var currentTempHeight: NSLayoutConstraint!
    
    let disposeBag = DisposeBag()
    var zipcode = Variable<String>("")
    var totalWeather = Variable<[[HourlyWeather]]>([])
    var responseURL: Variable<URL>?
    
    var blurView: UIVisualEffectView?
    var daysHourlyWeatherArray: [SectionOfHourlyData] = []

    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let network = RxNetworkLayer.shared

        let today = network.todaysWeather.map { (hourly) -> SectionOfHourlyData in
            let viewModels = hourly.map { HourlyCellViewModel(with: $0) }
            return SectionOfHourlyData(header: "Today", items: viewModels)
        }
        let tomorrow = network.tomorrowsWeather.map { (hourly) -> SectionOfHourlyData in
            let viewModels = hourly.map { HourlyCellViewModel(with: $0) }
            return SectionOfHourlyData(header: "Tomorrow", items: viewModels)
        }
        
        let other = network.otherWeather.map { (hourly) -> SectionOfHourlyData in
            let viewModels = hourly.map { HourlyCellViewModel(with: $0) }
            return SectionOfHourlyData(header: "Two Days From Now", items: viewModels)
        }
        
        let observable = Observable.zip([today, tomorrow, other]) { return $0 }
        formatRxDataSource(with: observable)
        
        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        collectionView.rx
            .willDisplayCell
            .subscribe(onNext: { observedCell in
                let cell = observedCell.cell
                UIView.animate(withDuration: 0.3) {
                    cell.transform = .identity
                }
            })
            .disposed(by: disposeBag)
        
        subscribeToCurrentWeather()
        subscribeToSettingsGear()
    }
    
    func formatRxDataSource(with observable: Observable<[SectionOfHourlyData]>) {
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "EmptyHeader")
        
        collectionView.rx.willDisplayCell
            .subscribe { (event) in
                UIView.animate(withDuration: 0.3, animations: {
                    event.element?.cell.transform = .identity
                })
            }
            .disposed(by: disposeBag)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfHourlyData>(configureCell: { (sectionData, collectionView, indexPath, viewModel) -> UICollectionViewCell in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCellID", for: indexPath) as? HourlyWeatherCollectionViewCell else {
                fatalError("Unable to dequeue correct cell type for given index path.")
            }
            cell.hourlyViewModel = viewModel
            return cell
        }, configureSupplementaryView:  { (sectionData, collectionView, kind, indexPath) -> UICollectionReusableView in
            if sectionData.sectionModels[indexPath.section].items.count == 0 {
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "EmptyHeader", for: indexPath)
            }
            
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderID", for: indexPath) as? DayHeaderView else {
                fatalError("Unable to dequeue correct header type for given index path.")
            }
            
            header.headerLabel.text = sectionData.sectionModels[indexPath.section].header
            return header
        })
        
        observable
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    func subscribeToCurrentWeather() {
        RxNetworkLayer.shared.currentWeather
            .map { return CurrentWeatherViewModel(with: $0) }
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { newWeather in
                self.currentWeatherBGView.currentWeatherViewModel = newWeather
            })
            .disposed(by: disposeBag)
    }
    
    func subscribeToSettingsGear() {
        self.currentWeatherBGView.settingsTapped
            .subscribe(onNext: { [weak self] button in
                self?.settingsButtonTapped(sender: button)
            })
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
    
    func settingsButtonTapped(sender: UIButton) {
        blurView = UIVisualEffectView(frame: self.view.frame)
        popOverToSettings(source: sender)
    }
    
    func popOverToSettings(source: UIView) {
        let settingsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "settingsID") as! SettingsViewController
        self.definesPresentationContext = true
        self.modalPresentationStyle = .currentContext
        
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
//                currentLocationLabelBottomConstraint.constant = (scrolledPastThreshold) > 90 ? 5 - ((30 + scrollView.contentOffset.y) / 2) : 5
            }
//            currentTempHeight.constant = min(scrolledPastThreshold, 90)
//            currentWeatherBottomConstraint.constant = scrollView.contentOffset.y
//            currentTempLabel.font = UIFont(name: currentTempLabel.font.fontName, size: min(scrolledPastThreshold, 90))
            UIView.animate(withDuration: 0, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
}

extension MainViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
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

