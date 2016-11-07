
//  Created by Mukesh Jha on 26/07/16.
import UIKit
import Alamofire

protocol ReportDownload {
    func OnFinishDownload(_ result:NSMutableArray,options :Array<OptionsData>,param:Params)
    func OnError(_ error:NSError)
}


class Report: NSObject {
  var result:NSMutableArray=NSMutableArray();
  var param:Params?
  var delegate: ReportDownload?
  var options :Array<OptionsData> = Array<OptionsData>()
   
  init(param:Params,delegate: ReportDownload) {
        self.param=param;
        self.delegate=delegate;
    }
  func LoadData(){
     let authkey = UserDefaults.standard.string(forKey: AUTHKEY)
    Alamofire.request(GETLIST,method:.post, parameters:
            [AUTHKEY:authkey!, LIMIT:(self.param?.Limit!)!,GROUP_ID: (self.param?.gid!)!,OFSET:(self.param?.offset!)!,TYPE:(self.param?.type!)!])
            .validate().responseJSON
            {response in switch response.result {
                
            case .success(let JSON):
            self.result=ParseJason().ParseReportJason(JSON as AnyObject,type: (self.param?.type!)!);
            self.options=ParseJason().ParseMenu(JSON as AnyObject);
            print("Success with JSON: \(JSON)")
            
            
            if(!(self.param?.isfilter)!){
                    var isUpdated:Bool=false;
                    var ismenu:Bool=false;
                    if(self.param?.isMore == true && (self.param?.filterpos)! == 0){
                       isUpdated = ModelManager.getInstance().insertData((self.param?.type)!, isDelete: false, Datas: self.result,isMore:self.param?.isMore == true)
                    }
                    else
                    {
                     isUpdated = ModelManager.getInstance().insertData((self.param?.type!)!, isDelete: true, Datas: self.result,isMore:self.param?.isMore == true)
                     ismenu = ModelManager.getInstance().insertMenu((self.param?.type!)!, Options: self.options)
                        
                        if ismenu {
                           print("\((self.param?.type!)!)_Menu updated successfully.")
                        } else {
                            print("Error in updating \((self.param?.type!)!) Menu")
                        }
                   }
                   if isUpdated {
                        print("\((self.param?.type!)!) updated successfully.")
                    } else {
                        print("Error in updating \((self.param?.type!)!).")
                    }
                }
                self.delegate?.OnFinishDownload(self.result,options: self.options,param: self.param!)
                
            case .failure(let error):
                 self.delegate?.OnError(error as NSError)
                }
                

              
                
        }
        
    }
 
    
    
    

}
