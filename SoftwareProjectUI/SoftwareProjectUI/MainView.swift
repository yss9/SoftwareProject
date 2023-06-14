import SwiftUI

struct MainView: View {
    @State private var id: String=""
    @State private var pw: String=""
    
    var body: some View {
        NavigationView{
            VStack{
                
                Image("photo1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                Text("Sharing Favorite")
                    .font(.system(size: 52))
                    .foregroundColor(Color.blue)
                    .offset(x:0 , y:-505)
                
                ZStack{
                    TextField("Enter Your Id", text: $id)
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .offset(x:0,y:-50)
                        
                    SecureField("Enter Your Password", text: $pw)
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .offset(x:0,y:10)
                    
                    NavigationLink(destination: MenuView()){
                        Text("로그인")
                    }.offset(x:160 , y:60)
                        
                    NavigationLink(destination: RegView()) {
                        Text("회원가입")
                    }.offset(x:-160, y:60)
                    
                }
                
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
