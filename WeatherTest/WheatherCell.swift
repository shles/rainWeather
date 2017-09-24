//
//  WheatherCell.swift
//  WeatherTest
//
//  Created by Артмеий Шлесберг on 24/09/2017.
//  Copyright © 2017 Jufy. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class WeatherCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var wheatherIcon: UIImageView!
    
    private var disposeBag = DisposeBag()
    
    func configured(with forecast: WeatherForecast) -> Self {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm dd MMMM"
        timeLabel.text = dateFormatter.string(from: forecast.time)
        temperatureLabel.text = forecast.temperature
        forecast.icon.asObservable()
            .subscribe(onNext: { [unowned self] in
                self.wheatherIcon.image = $0
            })
            .disposed(by: disposeBag)
        return self
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
}




