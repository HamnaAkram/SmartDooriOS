//
//  Get_data.swift
//  Smart Door
//
//  Created by Hamna on 6/30/21.
//

import Foundation
import SwiftUI

public class Get_data : ObservableObject{
    
    @Published var UserListData : [User] = []
    @Published var LogListData : [CellItem] = []
    @Published var ScannedImages : [ScannedImage] = []
    @Published var door: Bool = false
    @Published var system: Bool = false
    @Published var cctv: Bool = false
    @Published var face : String = "face found"
    @Published var name_error = false
    
    var res: [String: Any] = [:]

    
    init() {
        self.load_face_reg_data()
        self.load_log_data(url:"http://172.26.19.213/json_face_log")
        self.get_status()
        
       
    }
    
    func base64ImageConvert(base64String: String?) -> UIImage{
       if (base64String?.isEmpty)! {
           return #imageLiteral(resourceName: "no_image_found")
       }else {
           // !!! Separation part is optional, depends on your Base64String !!!
           let temp = base64String?.components(separatedBy: ",")
           let dataDecoded : Data = Data(base64Encoded: temp![0], options: .ignoreUnknownCharacters)!
           let decodedimage = UIImage(data: dataDecoded)
           return decodedimage!
       }
     }
    
    func toString(_ value: Any?) -> String {
      return String(describing: value ?? "")
    }
    
    
    func toBool(val : String) -> Bool{
        if val == "1" {
            return true
        }
        else {
            return false
        }
        
    }
    
    
    func get_status(){
        let (res,_) = NET_CONN().login_check(req_str: "http://172.26.19.213/json_getstatus")
        print(res)
        cctv = toBool(val : toString(res["cctv_rec"]))
        system = toBool(val : toString(res["is_disabled"]))
        door = toBool(val : toString(res["door"]))
        return
        
    }
    
    func load_face_reg_data() {
        let (res, _) = NET_CONN().login_check(req_str: "http://172.26.19.213/json_reg_list")   //res.keys -> user names ; res.values -> base64 image string
        for (key,value) in res{
            let ob = toString(value)
            let img = base64ImageConvert(base64String: ob)
            UserListData.append(User(id: UUID(), name: key, image: img))
            
            }
        return
    }
    
    func load_ser_detail_log(name: String) -> (String, UIImage, [CellItem]){
        var LogEntryDetail : [CellItem] = []
        var recenttime = "13:15"
        var count = 0
        var recentimage: UIImage = UIImage()
        
        let details = res[name] as! NSArray
        
        for entry in details{
            let entry_1 = entry as! NSDictionary
            let time = entry_1["time"] as! String
            let img_str = toString(entry_1["face"])
            let img = base64ImageConvert(base64String: img_str)
            LogEntryDetail.append(CellItem(head: time, time: " ", image: img))
            if (count == 0) {
                recenttime = time
                count = count+1
                recentimage = img
            }
        }
        
        return (recenttime,recentimage,LogEntryDetail)
    }
    
    
    func load_log_data(url: String){
       
        (res, _) = NET_CONN().login_check(req_str: url)
        for (key,_) in res {
            let (rtime,face,detail) = load_ser_detail_log(name: key)
            let time = "Recent Entry: " + rtime
            let user = CellItem(id:UUID() , head: key,time: time, image: face, subCellItems: detail)
            LogListData.append(user)
            }
        }
    
    func get_new_face(){
        print("Scanning")
        let (res, _) = NET_CONN().login_check(req_str: "http://172.26.19.213/json_scan")
        if res.count > 8 {
            for (_,value) in res {
                let str = toString(value)
                let img  = base64ImageConvert(base64String: str)
                ScannedImages.append(ScannedImage(id: UUID(), ScanUserImage: img))
            }
        }
        else {
            ScannedImages.removeAll()
        }
        
        print(ScannedImages)
        return
    }
    
    func save_user(name : String){
        var url = "http://172.26.19.213/json_saveface?name="
        url.append(name)
        let x = NET_CONN().login_check(req_str: url)
        let val = toString(x.0["status"])
        if val == "face_exist"{
            name_error = true
        }
        else{
            name_error = false
        }
        print(x)
        return
    }
    
    func delete_user(name : String){
        var url = "http://172.26.19.213/json_deleteface?name="
        url.append(name)
        _ = NET_CONN().login_check(req_str: url)
        
        return
    }
    
    
//    func get_dev_id(ip: String)
//    {
//        let url = "http://" + ip + ":8555/json_get_dev"
//        let (res,_) = NET_CONN().login_check(req_str: url)
//        for (_,value) in res{
//            let dev_id = toString(value)
//            let x = DeviceListItem(DeviceID: dev_id, DeviceName: ip, status: true, itemImage: "lock")
//            DeviceListData.append(x)
//
//            }
//    }
    
}



    
    
    
    
    

