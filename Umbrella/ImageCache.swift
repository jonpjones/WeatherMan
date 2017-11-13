//
//  ImageCache.swift
//  Umbrella
//
//  Created by Jonathan Jones on 11/13/17.
//  Copyright © 2017 The Nerdery. All rights reserved.
//

import Foundation
import RxSwift
import RxSwiftExt

struct ImageRef {
    let image: UIImage
    let url: URL
}

class ImageCache {
    private let disposeBag = DisposeBag()
    static var shared = ImageCache()
    private var observableURLS: Observable<URL>?
    let imageSubject = ReplaySubject<(URL, UIImage)>.createUnbounded()
    
    private init() {
        RxNetworkLayer.shared.totalWeather
            .map({ hourlyWeather -> [URL] in
                var urlArray: [URL] = []
                hourlyWeather.forEach({ hour in
                    guard
                        let url = hour.iconName.nrd_weatherIconURL(highlighted: (hour.tintColor != .black)),
                        !urlArray.contains(url) else {
                            return
                    }
                    urlArray.append(url)
                })
                return urlArray
            })
            .subscribe(onNext: { [weak self] urlArray in
                self?.observableURLS = Observable.from(urlArray)
            })
            .disposed(by: disposeBag)
        startDownloadTasks()
    }
    
    func startDownloadTasks() {
        self.observableURLS?
            .distinct()
            .flatMap ({ imageURL in
                return RxNetworkLayer.shared.fetchIcon(iconURL: imageURL)
            })
            .subscribe(onNext: { ref in
                if let url = ref?.url, let image = ref?.image.withRenderingMode(.alwaysTemplate)  {
                    self.imageSubject.onNext((url, image))
                }
            })
            .disposed(by: disposeBag)
    }
}
