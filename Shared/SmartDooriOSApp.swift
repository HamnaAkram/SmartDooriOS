//
//  SmartDooriOSAppApp.swift
//  Shared
//
//  Created by Hamna Akram on 2022/07/05.
//

import SwiftUI

@main
struct SmartDooriOSAppApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ZStack{
                    //DeviceView(ListItemsData: DeviceScanList(data:MockDataList.DeviceListData))
                    //DeviceScanView()
                    DeviceView_new()
                }
                    .navigationBarTitle("")
                    .navigationBarHidden(true)

            }
        }
    }
}

