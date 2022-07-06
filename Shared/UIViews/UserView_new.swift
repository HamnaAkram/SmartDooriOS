

import SwiftUI
import Foundation



struct User: Identifiable {
    var id = UUID()
    var name: String
    var image: UIImage

}


struct ScannedImage: Identifiable {
    var id: UUID
    var ScanUserImage: UIImage
}
 

struct UserView_new: View {
   
    @EnvironmentObject var data : Get_data
    @State private var showingNewUserSheet = false
    var body: some View {
        ZStack{
            
            VStack{
                Divider()
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                HStack{
                    Text("\(data.UserListData.count) Users")
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .padding(.leading, 12)
                    .padding(.top, 8)
                Spacer()
                    Button {
                                showingNewUserSheet.toggle()
                                
                    } label :{
                        Image(systemName: "person.crop.circle.badge.plus")
                            .foregroundColor(Color.blue)
                            .font(.system(size: 25))
                            .padding(.trailing, 12)
                            .padding(.top, 8)
                    }
                    .sheet(isPresented: $showingNewUserSheet) {
                        NavigationView{
                        RegisterUser_View().environmentObject(data)
                        }
                    }
                }
                List {
                    ForEach(data.UserListData) { item in
                    
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
                            Text("\(item.name)")
                                .lineLimit(nil)
                                .foregroundColor(.primary)
                                
                        }
                        
                    }
                    
                    } .onDelete(perform: delete)
            }
                .listStyle(InsetGroupedListStyle())
                .padding(.top,0)
                
                
                
                
              
            }
        }
        .navigationBarTitle("Registered Users")

        
    }
    
    func delete(at offsets: IndexSet) {
        
        for i in offsets{
                let name = data.UserListData[i].name
                data.delete_user(name: name)
                print("User Deleted")

        }
        data.UserListData.remove(atOffsets: offsets)
        

       }}




    
    


