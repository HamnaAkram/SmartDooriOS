//
//  LogView_new.swift
//  Smart Door
//
//  Created by Hamna on 7/2/21.
//

import SwiftUI
import Foundation

struct CellItem: Identifiable {
    var id = UUID()
    var head: String
    var time: String
    var image: UIImage
    var subCellItems: [CellItem]?
}




struct LogView_new: View {
    let url = "http://172.26.19.213:8555/json_reg_list"
    @State var selectedDay = Date()
    @EnvironmentObject var data : Get_data
    
    var body: some View {
        ZStack{
            /*Color(red: 242 / 255, green: 242 / 255, blue: 247 / 255)
            .ignoresSafeArea()*/
            
            VStack{
                let dateBinding = Binding(
                    get: { self.selectedDay },
                    set: {
                        //print("Old value was \(self.selectedDay) and new date is \($0)")
                        self.selectedDay = $0
                        self.reload_getdate()
                        
                    }
                   
                )
                VStack {
                    DatePicker("Please Select a Date: ", selection: dateBinding, in: ...Date(), displayedComponents: [.date])
                        .fixedSize()
                        .font(.system(size: 16, design: .default))
                        .padding(.leading,5)
                        .padding(.top, 10)
                }
                
                List(data.LogListData, children: \.subCellItems) { item in
                    
                    
                    HStack {
                        Image(uiImage: item.image)
                            .renderingMode(.original)
                            .resizable()
                            .cornerRadius(30)
                            .frame(width: 60, height: 60)
                            .padding(.trailing, 5)
                            .padding(.leading, 5)
                            .padding(.top,7)
                 
                        VStack(alignment: .leading, spacing: 3) {
                            HStack {
                                Spacer()
                            }
                            Text("\(item.head)")
                                .lineLimit(nil)
                                .foregroundColor(.primary)
                            Text("\(item.time)")
                                .foregroundColor(.primary)
                                .font(.system(size: 12))
                                
                        }
                         
                    }
                }.listStyle(InsetGroupedListStyle())
                .padding(.top,0)
                
                
                
                
              
            }
        }
        .navigationBarTitle("User Log")

        
    }
    
    func reload_getdate()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDate = dateFormatter.string(from: self.selectedDay)
        var url = "http://172.26.19.213:8555/json_face_log?date="
        url.append(selectedDate)
        print(url)
        data.LogListData.removeAll()
        data.load_log_data(url: url)
    }
}
   
        
struct LogView_new_Previews: PreviewProvider {
    static var previews: some View {
        LogView_new()
    }
}
   

    
    

