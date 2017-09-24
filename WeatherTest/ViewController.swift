//
//  ViewController.swift
//  WeatherTest
//
//  Created by Артмеий Шлесберг on 24/09/2017.
//  Copyright © 2017 Jufy. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let dataSource = RxTableViewSectionedReloadDataSource<StandardSectionModel<WeatherForecast>>()
        
        dataSource.configureCell = { ds, tv, ip, item in
            return (tv.dequeueReusableCell(withIdentifier: "weather", for: ip) as! WeatherCell).configured(with: item)
        }
        
        WeatherForecastsFromAPI().asObservable()
//            .catchErrorJustReturn([FakeForecast()])
            .map{ [ StandardSectionModel<WeatherForecast>(items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
        
        ImageFromFlickr()
        .bind(to: backgroundImageView.rx.image)
        .disposed(by: disposeBag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

