//
//  DeviceScanView.swift
//  28
//
//  Created by Hamna on 2022/01/26.
//

import SwiftUI

//class NetworkScanSettings: ObservableObject {
//    @Published var scanning = true
//    @Published var done = false
//}


struct DeviceView_new : View {
    //@StateObject var network_settings = NetworkScanSettings()
    @StateObject var network_scan = NetworkScan()
    @ViewBuilder

    var body: some View {
        if network_scan.StartScan{
            DeviceScanView().environmentObject(network_scan)
        }
        else if !network_scan.StartScan{
            DeviceView().environmentObject(network_scan)
        }
        
        
    }


}



struct DeviceScanView: View {
    @EnvironmentObject var network_scan : NetworkScan
    var body: some View {
        ZStack{
            HStack{
                ProgressView(value: network_scan.progressValue)
                    .padding([.leading, .trailing], 10)
                Button {
                    network_scan.scanButtonClicked()
                    
                        
                } label :{
                    Image(systemName: "repeat")
                        .foregroundColor(Color.blue)
                        .font(.system(size: 25))
                        .padding(.trailing, 12)
                        .padding(.top, 8)
                }
            }
            VStack{
                
            }
        
        }
    }
}

struct DeviceScanView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceScanView()
    }
}
