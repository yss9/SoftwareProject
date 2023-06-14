import SwiftUI

struct MenuView: View {
    var body: some View {
        VStack{
            NavigationLink(destination: SharedPostListView()){
                Text("Shared Post List")
                    
            }.buttonStyle(DefaultButtonStyle())
             .foregroundColor(Color.blue)
             .padding()
             
            
            NavigationLink(destination: CreatePostView()){
                Text("Create Post")
                    
            }.buttonStyle(DefaultButtonStyle())
             .foregroundColor(Color.blue)
             .padding()
             
            
            NavigationLink(destination: PostedListView()){
                Text("Posted List")
                    
            }.buttonStyle(DefaultButtonStyle())
             .foregroundColor(Color.blue)
             .padding()
             
         
        }
        .padding()
        .font(.system(size : 24))
    }
}
struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
