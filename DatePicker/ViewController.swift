//
//  ViewController.swift
//  DatePicker
//
//  Created by vbn on 2018/7/2.
//  Copyright © 2018年 pori. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let picker = KNDatePicker.init(frame: CGRect(x: 0, y: 200, width: self.view.bounds.width/2 - 20, height: 200), defaultStyle: .YearAndMonthAndDay)
        picker.needHiddenUnit = true
        picker.defaultDate = Date(year: 2017, month: 12, day: 12)

        picker.selectedDateClosure = { date in
            print(date)
        }
        self.view.addSubview(picker)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

