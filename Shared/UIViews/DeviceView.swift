//
//  ContentView.swift
//  Shared
//
//  Created by Hamna on 2/18/21.
//

import SwiftUI
import Combine


//class DeviceScanList: ObservableObject {
//    let objectWillChange = PassthroughSubject<Void, Never>()
//
//    var DeviceScanListArray : [DeviceListItem] {
//       willSet {
//            objectWillChange.send()
//        }
//    }
//
//    init(data: [DeviceListItem] ) {
//        self.DeviceScanListArray = data
//    }
//}

struct DeviceListItem: Identifiable {
    var id = UUID()
    var DeviceID: String
    var DeviceName: String
    var status: Bool
    var itemImage: String
}


struct DeviceView : View {
    
    //@ObservedObject var ListItemsData : DeviceScanList
    @EnvironmentObject var data : NetworkScan
    
    var body: some View {
        NavigationView{
        GeometryReader { geometry in
            VStack {
                Divider()
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    HStack {
                        Text("\(data.DeviceListData.count) devices")
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .padding(.leading, 12)
                            .padding(.top, 8)
                        Spacer()
                        Button(action: {
                            //print("Edit Cells")
                        }){
                            Image(systemName: "apps.iphone.badge.plus")
                        }.foregroundColor(Color.blue)
                        .padding(.trailing, 12)
                        .padding(.top, 8)
                    }
                    .navigationBarTitle("Devices")
                ScrollView (.vertical, showsIndicators: false) {
                    VStack (alignment: .leading) {
                        ForEach(data.DeviceListData){ item in
                            DeviceListCellView(ListItem: item)
                                .frame(width: geometry.size.width - 24, height: 80)
                                
                            }
                    }
                }
                //.frame(height: 87 * 4)
                
                Spacer()
                    .padding(.top, 10)
                    .padding(.bottom, 20)
            }
          
            }
        }
        .onAppear{
        }
    }
}
        
        
struct DeviceListCellView: View {
    var ListItem: DeviceListItem
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack (spacing: 10) {
                    Image("\(self.ListItem.itemImage)")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .padding(.trailing, 5)
                        .padding(.leading, 5)
                        .padding(.top, 7)
                    
                    VStack(alignment: .leading, spacing: 3) {
                        HStack {
                            Spacer()
                        }
                        Text("\(self.ListItem.DeviceID)")
                            .lineLimit(nil)
                            .foregroundColor(.primary)
                        Text("\(self.ListItem.DeviceName)")
                            .foregroundColor(.primary)
                            .font(.system(size: 12))
                            .foregroundColor(Color.gray)
                    }.frame(width: geometry.size.width - 200)
                    //.padding(.top, 8)
                    VStack(alignment: .center){
                        HStack {
                            Spacer()
                        }
                        NavigationLink(destination: DashboardView()){
                            Image(systemName: "note.text.badge.plus")
                        }
                            .font(.system(size: 16))
                            .foregroundColor(.blue)
                            .padding(.trailing, 5)
                           
                          
                    }
                    //.padding(.top, 8)
                    VStack(alignment: .trailing){
                        HStack {
                            Spacer()
                        }
                        NavigationLink(destination: Streaming_View()){
                            Image(systemName: "play.tv")
                        }
                            .font(.system(size: 16))
                            .foregroundColor(.green)
                            .padding(.trailing, 5)
                       /* Button(action: {print("hello")}, label: {
                            Image(systemName: "play.tv")
                        }) .disabled(true)
                            .font(.system(size: 16))
                            .foregroundColor(.green)
                            .padding(.trailing, 10)*/
                           
                          
                    }
                    
                }
                
               /* Divider()
                    .background(Color.red)
                    .font(.system(size:22))*/
            }
        }.background(Color("gray1"))
        .cornerRadius(10)
        
       
    }
}

    
//struct ContentView : View {
//    var body : some View {
//        NavigationView {
//            ZStack{
//                //DeviceView(ListItemsData: DeviceScanList(data:MockDataList.DeviceListData))
//                //DeviceScanView()
//                DeviceView_new()
//            }
//                .navigationBarTitle("")
//                .navigationBarHidden(true)
//
//        }
//    }
//}


