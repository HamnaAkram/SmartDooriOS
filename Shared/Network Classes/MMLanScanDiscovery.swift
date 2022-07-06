//
//  MMLanScanDiscovery.swift
//  28
//
//  Created by Hamna on 2022/01/26.
//

import Foundation


public class NetworkScan : NSObject, MMLANScannerDelegate, ObservableObject {
    
    var lanScanner : MMLANScanner!
    @Published dynamic var connectedDevices : [MMDevice] = []
    @Published dynamic var progressValue : Float = 0.0
    @Published dynamic var isScanRunning : BooleanLiteralType = false
    @Published dynamic var StartScan : BooleanLiteralType = false
    @Published dynamic var DeviceListData : [DeviceListItem] = []
    override init() {
        super.init()
        self.lanScanner = MMLANScanner(delegate: self)
        print("Starting SCan")
        self.isScanRunning = false
        self.StartScan = true
     
    }
    
    
    public func lanScanDidFindNewDevice(_ device: MMDevice!) {
        //Adding the found device in the array
        print("Foud New Device")
        if(!self.connectedDevices .contains(device)) {
            self.connectedDevices.append(device)
        }

        let ipSortDescriptor = NSSortDescriptor(key: "ipAddress", ascending: true)
        self.connectedDevices = (self.connectedDevices as NSArray).sortedArray(using: [ipSortDescriptor]) as! Array
        
        return
    }
    
    public func lanScanDidFailedToScan() {
        
        self.isScanRunning = false
        //self.delegate?.mainPresenterIPSearchFailed()
    }
    
    public func lanScanDidFinishScanning(with status: MMLanScannerStatus) {
        //var result: (Data?, URLResponse?, Error?)! = nil
        self.isScanRunning = false
        self.StartScan = false
        print("Finsih Scan")
        //Checks the status of finished. Then call the appropriate method
        if (status == MMLanScannerStatusFinished) {
            print(self.connectedDevices)
            connectedDevices.remove(at: 0)
            for device in connectedDevices {
               let ip = device.ipAddress!
                print(type(of: ip))
                print("Looking for device:" , device.ipAddress!)
//                ip = "http://" + ip
//                let x = "http://172.26.19.97"
//                let x = ""
                let client = TCPClient(address: ip ,port: 80)
//                print(client)
                switch client.connect(timeout: 1) {
                  case .success:
                    let dev_ip = ip
                    print("success")
                    client.close()
                    let url = "http://" + dev_ip + ":80/json_get_dev"
                    let (res,_) = NET_CONN().login_check(req_str: url)
                    for (_,value) in res{
                        let dev_id = String(describing: value )
                        let x = DeviceListItem(DeviceID: dev_id, DeviceName: ip, status: true, itemImage: "lock")
                        DeviceListData.append(x)
                    }
                    
                case .failure(let error):
                    print("Failure")
                    print(error)
                    continue
                }
                
        }
        }
        else if (status == MMLanScannerStatusCancelled) {

            print("Scan Cancelled")
        }
        
        
    }
    

    public func lanScanProgressPinged(_ pingedHosts: Float, from overallHosts: Int) {
       
        //Updating the progress value. MainVC will be notified by KVO
        self.progressValue = pingedHosts / Float(overallHosts)
    }
    
    func scanButtonClicked()-> Void {
    
            if (self.isScanRunning) {
    
                self.stopNetWorkScan()
            }
            else {
    
                self.startNetWorkScan()
            }
        }
    
        func startNetWorkScan() ->Void{
    
            if (self.isScanRunning) {
    
                self.stopNetWorkScan()
                self.connectedDevices.removeAll()
            }
            else {
                self.connectedDevices.removeAll()
                self.isScanRunning = true
                self.lanScanner.start()
            }
        }
    
        func stopNetWorkScan() ->Void{
    
            self.lanScanner.stop()
            self.isScanRunning = false
        }
    
        //MARK: - SSID Info
        //Getting the SSID string using LANProperties
        func ssidName() -> String {
    
            return LANProperties.fetchSSIDInfo()
        }
    
    
}
