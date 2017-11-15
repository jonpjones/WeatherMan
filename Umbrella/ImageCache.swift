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
    
    private var iconURLSubject = ReplaySubject<URL?>.createUnbounded()
    
    let imageSubject = ReplaySubject<(URL, UIImage)>.createUnbounded()
    
    private init() {
        
        let today = RxNetworkLayer.shared.todaysWeather
        let tomorrow = RxNetworkLayer.shared.tomorrowsWeather
        let other = RxNetworkLayer.shared.otherWeather
        Observable.zip(today, tomorrow, other)
            .flatMap { (weather) -> Observable<[HourlyWeather]> in
                let (first, second, third) = weather
                return Observable.of([first, second, third].flatMap { $0 })
            }
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
                for url in urlArray {
                    self?.iconURLSubject.onNext(url)
                }
            })
            .disposed(by: disposeBag)
        
        
        self.iconURLSubject
            .flatMap { url -> Observable<ImageRef?> in
                if let unwrappedURL = url {
                    return self.fetchIcon(iconURL: unwrappedURL)
                }
                return Observable.empty()
            }
            .retry(3)
            .subscribe(onNext: { ref in
                if let url = ref?.url, let image = ref?.image.withRenderingMode(.alwaysTemplate)  {
                    self.imageSubject.onNext((url, image))
                }
            }, onError: { error in
                print("error")
            })
            .disposed(by: disposeBag)
    }
}

extension ImageCache {
    func fetchIcon(iconURL: URL) -> Observable<ImageRef?> {
        let request = URLRequest(url: iconURL)
        if let data = URLCache.shared.cachedResponse(for: request)?.data {
            if let image = UIImage(data: data) {
                return Observable.of(ImageRef(image: image, url: iconURL))
            }
        }

        return URLSession.shared.rx.response(request: request)
            .do(onNext: { (response, data) in
                let cache = CachedURLResponse(response: response, data: data)
                URLCache.shared.storeCachedResponse(cache, for: request)
            })
            .map({ (_, data) -> ImageRef? in
                if let image = UIImage(data: data) {
                    return ImageRef(image: image, url: iconURL)
                } else {
                    return nil
                }
            })
    }
}

