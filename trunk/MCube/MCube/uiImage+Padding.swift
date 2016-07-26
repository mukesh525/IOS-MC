
import UIKit
extension UIImage {
    func imageWithInsets(insets: UIEdgeInsets) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(
            CGSizeMake(self.size.width + insets.left + insets.right,
                self.size.height + insets.top + insets.bottom), false, self.scale)
        _ = UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.drawAtPoint(origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets
  }
}

extension UIDatePicker {
    func getStringValue() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formatteddate = dateFormatter.stringFromDate(self.date)
        return formatteddate
    }
}

extension String {

func getDateFromString() -> String {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = NSTimeZone(name: "UTC")
    guard let date = dateFormatter.dateFromString(self) else {
        assert(false, "no date from string")
        return ""
    }
    dateFormatter.dateFormat = "dd-MM-yyyy"
    let timeStamp = dateFormatter.stringFromDate(date)
    return timeStamp
   }
    
    func getTimeFromString() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        guard let date = dateFormatter.dateFromString(self) else {
            assert(false, "no date from string")
            return ""
        }
        dateFormatter.dateFormat = "hh:mm a"
        let timeStamp = dateFormatter.stringFromDate(date)
        return timeStamp
    }
    
    func convertDateFormater() -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        
        guard let date = dateFormatter.dateFromString(self) else {
            assert(false, "no date from string")
            return NSDate()
        }
        //let timeStamp = dateFormatter.stringFromDate(date)
        return date
    }
    
    
    
    
}


