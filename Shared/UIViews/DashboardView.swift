//
//  DashboardView.swift
//  Smart Door
//
//  Created by Hamna on 3/16/21.
//

import SwiftUI



struct DashboardView: View {
    @State private var doorToggle = false
    @State private var systemUsage = false
    @State private var cctv = false
    @StateObject var data = Get_data()
    @State private var showingAlert = false
    

    
    
    var body: some View {

        VStack{
            Form {
                
                Section(header: Text("System Controls")) {
                    VStack{
                    Toggle(isOn: $data.door) {
                        Image(systemName: "arrow.up.doc.on.clipboard")
                          Text("Open Door")
                    }
                    .onChange(of: data.door) { value in
                        if value{
                            let res =  NET_CONN().login_check(req_str: "http://172.26.19.213/json_control?action=door&val=true")
                            print("door open")
                            data.get_status()
                        }
                        if value == false {
                            let res =  NET_CONN().login_check(req_str: "http://172.26.19.213/json_control?action=door&val=false")
                            print ("door close")
                            data.get_status()
                        }
                    
                                }
                    
                        
                        
                        
                    
                   
                    Toggle(isOn: $data.system) {
                        Image(systemName: "iphone.homebutton.slash")
                        Text("Enable System")
                    }
                    .onChange(of: data.system) { value in
                        if value{
                            let res =  NET_CONN().login_check(req_str: "http://172.26.19.213/json_control?action=system_disable&val=true")
                            print ("System Enabled")
                            data.get_status()
                        }
                        if value == false {
                            let res =  NET_CONN().login_check(req_str: "http://172.26.19.213/json_control?action=system_disable&val=false")
                            print("System Disabled")
                            
                            data.get_status()
                        }
                    
                                }
                    Toggle(isOn: $data.cctv) {
                        Image(systemName: "video.bubble.left.fill")
                        Text("Disable CCTV Recording") }
                    .onChange(of: data.cctv) { value in
                        if value{
                            let res =  NET_CONN().login_check(req_str: "http://172.26.19.213/json_control?action=cctv_rec&val=true")
                            print("Recording Video")
                            data.get_status()
                        }
                        if value == false {
                            let res =  NET_CONN().login_check(req_str: "http://172.26.19.213/json_control?action=cctv_rec&val=false")
                            print ("Not Recording")
                            data.get_status()
                        }
                    
                                }
                    }
                    
                }
                
                
                //__________________________________View Starts__________________________________________
                
              
                Section(header: Text("User Information")) {
                    
                    NavigationLink(destination: UserView_new().environmentObject(self.data)) {
                    Image(systemName: "person.crop.circle.fill")
                    Text("User Management")
                    }
                   
                    NavigationLink(destination: LogView_new().environmentObject(self.data)) {
                        Image(systemName: "tablecells.fill")
                        Text("Entry Log")
                    }
                }
                
                    

        }
        .navigationBarTitle("Dashboard")
            .onAppear(perform: {
               
            })
            
    }
}
    
}


