//
//  RegisterUser_View.swift
//  28
//
//  Created by Hamna on 2021/11/15.
//

import SwiftUI


class ScanSettings: ObservableObject {
    @Published var scanning = true
    @Published var scanAmount = 0.0
    @Published var save = false
    @Published var empty = false
}

struct RegisterUser_View: View {
    @StateObject var settings = ScanSettings()
    @EnvironmentObject var data : Get_data
    @ViewBuilder
    var body: some View {
        if settings.scanning{
            Progress_View().environmentObject(settings).environmentObject(data)
        }
        if settings.save{
            SaveUser_View().environmentObject(data)
        }
        if settings.scanning == false && settings.empty == false{
            ScannedImageDisplay_View().environmentObject(data).environmentObject(settings)
        }
        if settings.empty{
            NoFaceFoundView_View()
        }
    }
}




struct NoFaceFoundView_View: View {
    @State var showingAlert = true
    @Environment(\.presentationMode) var presentationMode
    var body: some View{
        VStack{
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"),
                message: Text("No face found. Please ensure there is a person in the device view."),
                dismissButton: Alert.Button.default(
                    Text("OK"), action: { presentationMode.wrappedValue.dismiss() }
                )
            )

                }
        
        
    }
}

struct AlertItem: Identifiable {
    var id = UUID()
    var title: Text
    var message: Text?
    var dismissButton: Alert.Button?
}





struct SaveUser_View: View {
    @State private var name : String = ""
    @EnvironmentObject var data : Get_data
    @Environment(\.presentationMode) var presentationMode
//    @State var showSuccessAlert = false
//    @State var showFailAlert = false
    @State var showAlert = false
    @State private var alertItem: AlertItem?


    
    var body: some View{
        VStack{
            Text("Please enter a username for saving the new user.")
            TextField("", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.all, 20)
            Button(action: {
                data.save_user(name: name)
                if data.name_error{
                    //showFailAlert = true
                    self.alertItem = AlertItem(title: Text("Error"), message: Text("Username Exists Already. Please enter a new name."), dismissButton: Alert.Button.default(
                        Text("OK"), action: { data.name_error = false
                        }
                    ))
                }
                else
                {
                    //showSuccessAlert = true
                    self.alertItem = AlertItem(title: Text("Success"), message: Text("User saved successfully."), dismissButton: Alert.Button.default(
                        Text("OK"), action: { presentationMode.wrappedValue.dismiss()
                        }
                    ))
                    data.UserListData.removeAll()
                    data.LogListData.removeAll()
                    data.load_face_reg_data()
                    data.load_log_data(url:"http://172.26.19.213:8555/json_face_log")
                    
                }
                
            }) {
                HStack {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Save")
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(40)
            }

        }
        .alert(item: $alertItem) { alertItem in
                    Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
                }
        
        
//        .alert(isPresented: $showSuccessAlert) {
//            Alert(title: Text("Success"),
//                message: Text("User Saved Successfully"),
//                dismissButton: Alert.Button.default(
//                    Text("OK"), action: { presentationMode.wrappedValue.dismiss() }
//                )
//            )
//
//                }
//
//        .alert(isPresented: $showFailAlert) {
//            Alert(title: Text("Error"),
//                message: Text("Username Exists Already. Please enter a new name."),
//                dismissButton: Alert.Button.default(
//                    Text("OK"), action: { data.name_error = false
//                        showFailAlert = false
//                        showSuccessAlert = false
//                    }
//                )
//            )
//
//                }
    }
}

struct Progress_View: View {   //To show the progress bar while scanning
    @EnvironmentObject var settings: ScanSettings
    @EnvironmentObject var data : Get_data
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    

    var body: some View {
        VStack{
            ProgressView(value:settings.scanAmount,total:10)
                .padding(.trailing, 10)
                .frame(maxWidth: 300, maxHeight: 100, alignment: .center)
            Text("Scanning for faces......")
        } .onAppear{
            data.get_new_face()
            if data.ScannedImages.count == 0 {
                settings.empty = true
            }
        }
        .navigationBarTitle("Scanning")
        .onReceive(timer) {_ in
            if settings.scanAmount < 5 {
                settings.scanAmount += 1
            }
            else {
                self.timer.upstream.connect().cancel()
                settings.scanning.toggle()
            }
        }
    }
        
    }




struct ScannedImageDisplay_View:View {
    @EnvironmentObject var data : Get_data
    @EnvironmentObject var settings : ScanSettings
    var ColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View{
        ZStack{
            VStack{
                ScrollView{
                    LazyVGrid(columns: ColumnGrid ){
                        ForEach(data.ScannedImages) { object in
                                        Image(uiImage: object.ScanUserImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 150, height: 150, alignment: .center)
                                    }
                            }
                        
                }
            }
        .navigationTitle("New User")
        .toolbar {
            ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                            Button("Save") {
                                settings.save.toggle()
                               }
                           }
        }
    }
    
}
}


