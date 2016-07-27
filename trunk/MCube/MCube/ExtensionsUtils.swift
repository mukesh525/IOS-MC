
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
        dateFormatter.dateFormat = DATETIMEFOEMAT
        let formatteddate = dateFormatter.stringFromDate(self.date)
        return formatteddate
    }
}

extension _ArrayType where Generator.Element == DetailData {

    func getParams(currentData:Data,type:String)->[String: AnyObject]?{
        let authkey = NSUserDefaults.standardUserDefaults().stringForKey(AUTHKEY)
        var parameters: [String: AnyObject]? = [:]
        print(self.count)
        parameters![AUTHKEY]=authkey
        parameters![TYPE]=type
        parameters![GROUP_NAME]=(currentData.groupName != nil ? currentData.groupName : currentData.empName)!
        
        for curentValue in  self{
            
            if(curentValue.Type == CHECKBOX){
                var val=[String]()
                for option in curentValue.OptionList{
                    if(option.isChecked){
                        val.append(option.id!)
                    }
                }
                
                if(val.count>0){
                    let joined=val.joinWithSeparator(",")
                    print("\(curentValue.Name!)  :   \(joined)")
                    parameters![curentValue.Name!] = joined
                    
                }else{
                    print("\(curentValue.Name!)  :  null")
                    
                    parameters![curentValue.Name!] = "null"
                    
                    
                }
                
            }else if(curentValue.Type == DROPDOWN){
                print("\(curentValue.Name!)  :   \(curentValue.value!)")
                parameters![curentValue.Name!] = curentValue.value!
            } else {
                print("\(curentValue.Name!)  :   \(curentValue.value!)")
                parameters![curentValue.Name!] = curentValue.value!
            }
            
        }
        print(parameters!.keys.count) // 0
        
        return parameters
        
    }
  

}

extension String {

func getDateFromString() -> String {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = DATETIMEFOEMAT
    dateFormatter.timeZone = NSTimeZone(name: "UTC")
    guard let date = dateFormatter.dateFromString(self) else {
        assert(false, "no date from string")
        return ""
    }
    dateFormatter.dateFormat = DATETIMEFOEMAT
    let timeStamp = dateFormatter.stringFromDate(date)
    return timeStamp
   }
    
    func getTimeFromString() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = DATETIMEFOEMAT
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
        dateFormatter.dateFormat = DATETIMEFOEMAT
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        
        guard let date = dateFormatter.dateFromString(self) else {
            assert(false, "no date from string")
            return NSDate()
        }
        //let timeStamp = dateFormatter.stringFromDate(date)
        return date
    }
    
     func  capitalizeIt()-> String {
        if isEmpty { return "" }
        var result = self
        result.replaceRange(startIndex...startIndex, with: String(self[startIndex]).uppercaseString)
        return result    }
    
    
}


