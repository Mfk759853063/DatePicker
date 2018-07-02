//
//  KNDatePicker.swift
//  DatePicker
//
//  Created by vbn on 2018/7/2.
//  Copyright © 2018年 pori. All rights reserved.
//

import UIKit
import DateToolsSwift

enum KNDatePickerStyle: String {
    case YearAndMonthAndDay
    case YearAndMonth
    case Year
}

class KNDatePicker: UIView,UIPickerViewDelegate,UIPickerViewDataSource {
    var style: KNDatePickerStyle
    var needHiddenUnit = false {
        didSet {
            self.pickerView.reloadAllComponents()
        }
    }
    var normalColor: UIColor? {
        didSet {
            self.pickerView.reloadAllComponents()
        }
    }
    var selectColor: UIColor? {
        didSet {
            self.pickerView.reloadAllComponents()
        }
    }
    var maxDate: Date = NSDate.distantFuture {
        didSet {
            self.pickerView.reloadAllComponents()
        }
    }
    var minDate: Date = NSDate.init(timeIntervalSince1970: 0) as Date {
        didSet {
            self.pickerView.reloadAllComponents()
        }
    }
    var calendar: Calendar
    let pickerView: UIPickerView = UIPickerView()
    var currentComponent0 = 0
    var currentComponent1 = 0
    var currentComponent2 = 0
    var defaultDate = Date() {
        didSet {
            setup()
        }
    }
    var selectedDateClosure:((_ date: Date)->Void)?
    
    var numberOfYears: Int {
        return maxDate.years(from: minDate)
    }
    
    var numberOfMonthInYear: Int {
        return 12
    }
    
    var numberOfDaysInMonth: Int {
        return defaultDate.daysInMonth
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private override init(frame: CGRect) {
        style = .YearAndMonthAndDay
        calendar = Calendar.current
        super.init(frame: frame)
        pickerView.delegate = self
        pickerView.dataSource = self
        self.addSubview(pickerView)
        pickerView.frame = self.bounds
        normalColor = UIColor.black
        selectColor = UIColor.red
        
    }
    
    convenience init(frame: CGRect,defaultStyle: KNDatePickerStyle) {
        self.init(frame: frame)
        style = defaultStyle
        setup()
    }
    
    func setup() {
        setDefaultDate()
        var components = DateComponents()
        components.year = +30
        maxDate = Calendar.current.date(byAdding: components, to: Date())!
        pickerView.reloadAllComponents()
        
        
        if style == .Year {
            pickerView.selectRow(currentComponent0 - minDate.year, inComponent: 0, animated: true)
        } else if style == .YearAndMonthAndDay {
            pickerView.selectRow(currentComponent0 - minDate.year, inComponent: 0, animated: true)
            pickerView.selectRow(currentComponent1-1, inComponent: 1, animated: true)
            pickerView.selectRow(currentComponent2-1, inComponent: 2, animated: true)
        } else if style == .YearAndMonth {
            pickerView.selectRow(currentComponent0 - minDate.year, inComponent: 0, animated: true)
            pickerView.selectRow(currentComponent1-1, inComponent: 1, animated: true)
        }
    }
    
    func setDefaultDate(){
        currentComponent0 = defaultDate.year
        currentComponent1 = defaultDate.month
        currentComponent2 = defaultDate.day
    }
    
    // MARK: - PickerDelegate && Datasource
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if style == .Year {
            return 1
        } else if style == .YearAndMonth {
            return 2
        } else if style == .YearAndMonthAndDay {
            return 3
        }
        return 0
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if style == .Year {
            return numberOfYears
        } else if style == .YearAndMonthAndDay {
            if component == 0 {
                return numberOfYears
            } else if (component == 1) {
                return numberOfMonthInYear
            } else if (component == 2) {
                return numberOfDaysInMonth
            }
            return 0
        } else if style == .YearAndMonth {
            if component == 0 {
                return numberOfYears
            } else if (component == 1) {
                return numberOfMonthInYear
            }
        }
        return 0
        
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if style == .Year {
            return self.bounds.width
        } else if style == .YearAndMonthAndDay {
            return self.bounds.width/3
        } else if style == .YearAndMonth {
            return self.bounds.width/2
        }
        return self.bounds.width
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label:UILabel? = view as? UILabel
        if label == nil {
            label = UILabel()
            label?.textAlignment = .center
            label?.font = UIFont.systemFont(ofSize: 14)
        }
        
        label?.textColor = normalColor
        if style == .Year {
            let s = minDate.year+row
            let printStr = needHiddenUnit ? "\(s)":"\(s)年"
            label?.text = printStr
            if defaultDate.year == s {
                label?.textColor = selectColor
            }
        } else if style == .YearAndMonthAndDay {
            if component == 0 {
                let s = minDate.year+row
                let printStr = needHiddenUnit ? "\(s)":"\(s)年"
                label?.text = printStr
                if defaultDate.year == s {
                    label?.textColor = selectColor
                }
            } else if component == 1 {
                let printStr = needHiddenUnit ? String(format: "%02d", row+1):String(format: "%02d月", row+1)
                label?.text = printStr
                if defaultDate.month == row+1 {
                    label?.textColor = selectColor
                }
            } else if component == 2 {
                let printStr = needHiddenUnit ? String(format: "%02d", row+1):String(format: "%02d日", row+1)
                label?.text = printStr
                if defaultDate.day == row+1 {
                    label?.textColor = selectColor
                }
            }
        } else if style == .YearAndMonth {
            if component == 0 {
                let s = minDate.year+row
                let printStr = needHiddenUnit ? "\(s)":"\(s)年"
                label?.text = printStr
                if defaultDate.year == s {
                    label?.textColor = selectColor
                }
            } else if component == 1 {
                let printStr = needHiddenUnit ? String(format: "%02d", row+1):String(format: "%02d月", row+1)
                label?.text = printStr
                if defaultDate.month == row+1 {
                    label?.textColor = selectColor
                }
            }
        }
        
        return label!;
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if style == .Year {
            currentComponent0 = minDate.year+row
            defaultDate = Date.init(year: currentComponent0, month: currentComponent1, day: 1)
            
            self.pickerView.reloadAllComponents()
            if selectedDateClosure != nil {
                selectedDateClosure!(defaultDate)
            }
        } else if style == .YearAndMonthAndDay {
            if component == 0 {
                currentComponent0 = minDate.year+row
                defaultDate = Date.init(year: currentComponent0, month: currentComponent1, day: currentComponent2)
                self.pickerView.reloadComponent(2)
            } else if component == 1 {
                currentComponent1 = row+1
                defaultDate = Date.init(year: currentComponent0, month: currentComponent1, day: currentComponent2)
                self.pickerView.reloadComponent(2)
            } else if component == 2 {
                currentComponent2 = row+1
            }
            defaultDate = Date.init(year: currentComponent0, month: currentComponent1, day: currentComponent2)
            print(defaultDate)
            self.pickerView.reloadAllComponents()
        } else if style == .YearAndMonth {
            if component == 0 {
                currentComponent0 = minDate.year+row
            } else if component == 1 {
                currentComponent1 = row+1
            }
            defaultDate = Date.init(year: currentComponent0, month: currentComponent1, day: 1)
            
            self.pickerView.reloadAllComponents()
            if selectedDateClosure != nil {
                selectedDateClosure!(defaultDate)
            }
        }
        
        
    }
    
    
}
