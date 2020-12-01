//
//  CalenderPopUpViewController.swift
//  Beer Connect
//
//  Created by Synsoft on 12/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit

class CalenderPopUpViewController: BaseViewController {

   @IBOutlet weak var dateCalender: FSCalendar!
   @IBOutlet weak var btnDateSelected: UIButton!
   @IBOutlet weak var btnDateCancel: UIButton!
   @IBOutlet weak var datePickerBackView: UIView!
   var shippingDetailResponse: ShippingDetailResponse? = nil
   var minimumDate: Date? = Date()
   var maximumDate: Date? = Date()
   var selectedDate: Date? = Date()
   var selectedDateStr: String = Date.init().toString(dateFormat: "MM/dd/yyyy")
   
   weak var delegate: CalenderPopUpProtocol?
   var formattor = DateFormatter.init()
   
   override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    self.dateCalender.delegate = self
    self.dateCalender.dataSource = self
      view?.backgroundColor = UIColor(red: 19.0 / 255.0, green: 27.0 / 255.0, blue: 52.0 / 255.0, alpha: 0.5)
    self.manageCalenderMinMaxDates()
   }
   
   func manageCalenderMinMaxDates() {
      if let deliverDateSetting = self.shippingDetailResponse?.data?.deliveryDateSettings {
         
         if let miniDate = deliverDateSetting.minimumDate {
            
            var min = Int(miniDate) ?? 1
            min = min - 1
            let addDays: TimeInterval = (TimeInterval(60 * 60 * 24 * min))
            let currentDate = Date()
            self.minimumDate = currentDate.addingTimeInterval(addDays)
            selectedDate = self.minimumDate
            
            //dateCalender.select(selectedDate?.addingTimeInterval(addDays))
            //dateCalender.
         }
         
         if let maxDate = deliverDateSetting.maximumDate {
            let addDays: TimeInterval = (TimeInterval(60 * 60 * 24 * Int(maxDate)!))
            let currentDate = Date()
            self.maximumDate = currentDate.addingTimeInterval(addDays)
         }
         
       //  dateCalender.today = Date()
       
      }
   }
   
   
   @IBAction func cancDateMethodAction(_ sender: UIButton) {
      self.dismiss(animated: true, completion: nil)
   }
   
   @IBAction func userSelectDateMethodAction(_ sender: UIButton) {
      
      if dateCalender.selectedDate == nil {
         // selectedDate = minimumDate
        BaseViewController.showBasicAlert(message: NSLocalizedString("SELECT_DATE", comment: ""))
        return
      } else {
         selectedDate = self.dateCalender.selectedDate!
      }
      
      self.formattor.dateFormat = "MM/dd/yyyy"
      self.selectedDateStr = self.formattor.string(from: selectedDate ?? Date.init())
     
      print("Selected Date \(selectedDateStr)")
      self.delegate?.getSelectedDate(selectedDateStr: selectedDateStr)
      self.dismiss(animated: true, completion: nil)

//      let dateFormatter = DateFormatter()
//      let dateNewFormatter = DateFormatter()
//
//      dateFormatter.dateFormat = "yyyy-MM-dd"
//      dateNewFormatter.dateFormat = "MM/dd/yyyy"
//
//      if dateCalender.selectedDate == nil {
//         selectedDate = minimumDate
//      } else { selectedDate = dateCalender.selectedDate! }
//
//      let currentSelectedDate = dateFormatter.string(from: selectedDate)
//      self.btnDeliveryDate.setTitle(dateFormatter.string(from: selectedDate), for: .normal)
//
//      var weekDayAvailable = false
//      let weekDay = getWeekDayNo(weekday: (selectedDate.weekdayName))
//
//      guard let deliveryDateStr = self.viewModal?.shippingDetailResponse?.data?.deliveryDateSettings else { return }
//
//      guard let arrSelectDay = deliveryDateStr.selectedDay else { return }
//
//      guard let maxDate = deliveryDateStr.maximumDate else { return }
//      guard let minDate = deliveryDateStr.minimumDate else { return }
//
//      let currentDate = Date()
//      let minAddDays: TimeInterval = (TimeInterval(60 * 60 * 24 * Int(minDate)!))
//      let maxAddDays: TimeInterval = (TimeInterval(60 * 60 * 24 * Int(maxDate)!))
//
//      minimumDate = currentDate.addingTimeInterval(minAddDays)
//      selectedDate = minimumDate
//
//      maximumDate = currentDate.addingTimeInterval(maxAddDays)
//      selectedDate = maximumDate
//
//
//      if arrSelectDay.count > 0 {
//         for item in arrSelectDay {
//            print("Week Day \(weekDay)")
//            if item.lowercased().trim() == weekDay.lowercased().trim() {
//               weekDayAvailable = true
//               break
//            }
//         }
//      }
//
//      if weekDayAvailable == false {
//         self.btnDeliveryDate.setTitle("", for: .normal)
//         self.view?.makeToast("Selected Date is not available")
//         return
//      }
//
//      var countriesData = [String:String].init()
//
//      guard (self.viewModal?.shippingDetailResponse?.data?.countries) != nil else { return }
//      countriesData = self.viewModal?.shippingDetailResponse?.data?.countries ??
//         [String:String].init()
//      countriesData.values.forEach { value in
//         countries.append(value)
//      }
//
//      guard let arrHolidayDate = deliveryDateStr.holidayDate else { return }
//
//      if arrHolidayDate.count > 0 {
//         for item in arrHolidayDate {
//
//            let mainDate =da item.date?.lowercased().trim()
//            let dateTo = item.dateTo?.lowercased().trim()
//            let dayName = item.name?.lowercased().trim()
//
//            if (!(mainDate?.isEmpty ?? false) || (mainDate != "")) &&
//               (!(dateTo?.isEmpty ?? false) || (dateTo != "")) && (!(dayName?.isEmpty ?? false) || (dayName != "")){
//
//               let calendar = Calendar.current
//               let fmt = DateFormatter()
//               fmt.dateFormat = "dd/MM/yyyy"
//               let currentDateString = fmt.string(from: selectedDate)
//
//               let currentDate = convertToDate(dateString: currentDateString)
//               var startDate = convertToDate(dateString: item.date ?? "")
//               let endDate = convertToDate(dateString: item.dateTo ?? "")
//
//               while startDate <= endDate {
//                  if startDate == currentDate  {
//                     self.btnDeliveryDate.setTitle(dateFormatter.string(from: selectedDate), for: .normal)
//                     self.view?.makeToast("Selected Date is not available")
//                     return
//                  }
//                  startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
//               }
//            }
//         }
//      }
//
//      self.formattedDate = currentSelectedDate
//      self.getTimeSlots(selectedDate: currentSelectedDate.replacingOccurrences(of: "-", with: ""))
//      self.datePickerBackView.isHidden = true
   }
}

extension CalenderPopUpViewController: FSCalendarDelegate, FSCalendarDataSource {
    func minimumDate(for calendar: FSCalendar) -> Date {
//       if let deliverDateSetting = self.shippingDetailResponse?.data?.deliveryDateSettings {
//            if let miniDate = deliverDateSetting.minimumDate {
//               let addDays: TimeInterval = (TimeInterval(60 * 60 * 24 * Int(miniDate)!))
//               let currentDate = Date()
//               return currentDate.addingTimeInterval(addDays)
//            } else {
//                 return Date()
//            }
//        }
        return self.minimumDate ?? Date();
    }
    func maximumDate(for calendar: FSCalendar) -> Date {
//         if let deliverDateSetting = self.shippingDetailResponse?.data?.deliveryDateSettings {
//            if let maxDate = deliverDateSetting.maximumDate {
//               let addDays: TimeInterval = (TimeInterval(60 * 60 * 24 * Int(maxDate)!))
//               let currentDate = Date()
//              return currentDate.addingTimeInterval(addDays)
//            } else {
//                 return Date()
//            }
//        }
        return self.maximumDate ?? Date()
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        if (date.isBetween(self.minimumDate ?? Date(), and: self.maximumDate ?? Date())) {
            if (self.checkDeliveryAvailableForDate(date: date)) {
//                        if !((self.dateCalender?.selectedDate) != nil)  {
//                            self.dateCalender?.select(date)
//                        }
                       cell.isUserInteractionEnabled = true
                       cell.titleLabel.textColor = .black
                   } else {
                       cell.isUserInteractionEnabled = false
                       cell.titleLabel.textColor = .lightGray
                   }
        } else {
            cell.isUserInteractionEnabled = false
            cell.titleLabel.textColor = .lightGray
        }
        
    }
        
//    - (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventColorForDate:(NSDate *)date;
    
//    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
//
//        print("Dateeee",date)
//        let curDate = Date().addingTimeInterval(-24*60*60)
//
//        if date < curDate {
//            return false
//        } else {
//            return true
//        }
//    }
    
    @objc func checkDeliveryAvailableForDate(date: Date) -> Bool {
        if let deliverDateSetting = self.shippingDetailResponse?.data?.deliveryDateSettings {
            
            if deliverDateSetting.currentWeekDelivery != "1" {
                if Date().isInSameWeek(as: date) {
                    return false
                }
            }
            
            if deliverDateSetting.holidayDate?.count != 0 {
                var isHoliday = false
                for holidayDateData in deliverDateSetting.holidayDate ?? [] {
                    let dateFormatterHoliday = DateFormatter()
                    dateFormatterHoliday.dateFormat = "MM/dd/yyyy"
                    let fromDate = dateFormatterHoliday.date(from: holidayDateData.date ?? "")
                    let toDate = dateFormatterHoliday.date(from: holidayDateData.dateTo ?? "")
                    if fromDate != nil && toDate != nil {
                        if (date.isBetween(fromDate ?? Date(), and: toDate ?? Date())) {
                            isHoliday = true
                            break
                        }
                    }
                }
                
                if isHoliday {
                     return false
                }
            }
            
             let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            let weekDay = getWeekDayNo(weekday: (dateFormatter.string(from: date)))
            if let arrSelectDay = deliverDateSetting.selectedDay {
                 var weekDayAvailable = false
                 for item in arrSelectDay {
                        weekDayAvailable = false
                      // print("Week Day \(weekDay)")
                       if item.lowercased().trim() == weekDay.lowercased().trim() {
                          weekDayAvailable = true
                          break
                       }
                 }
                return weekDayAvailable
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    
    @objc func getWeekDayNo(weekday: String)->String
    {
        switch(weekday.lowercased()){
            case "sunday":
                return "0"
            case "monday":
                return "1"
            case "tuesday":
                return "2"
            case "wednesday":
                return "3"
            case "thursday":
                return "4"
            case "friday":
                return "5"
            case "saturday":
                return "6"
            default:
                break
        }
        return ""
    }

}


extension Date {
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
          return (date1.compare(self) == .orderedAscending || date1.compare(self) == .orderedSame) && (date2.compare(self) == .orderedDescending || date2.compare(self) == .orderedSame)
    }
    
    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }

    func isInSameWeek(as date: Date) -> Bool { isEqual(to: date, toGranularity: .weekOfYear) }

}
