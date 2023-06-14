import SwiftUI

struct CreatePostView: View {
    var body: some View {
        VStack{
            Text("Create Post")
                .font(.largeTitle)
                .fontWeight(.medium)
                .foregroundColor(Color.black)
                .offset(x:0,y:-240)
            VStack{
               NavigationLink(destination: CreateUIView()){
                    Text("Movie")
                    
                }.buttonStyle(DefaultButtonStyle())
                    .foregroundColor(Color.blue)
                    .padding()
                
                NavigationLink(destination: Book()){
                    Text("Book")
                    
                }.buttonStyle(DefaultButtonStyle())
                    .foregroundColor(Color.blue)
                    .padding()
                
                NavigationLink(destination: ArtMuseum()){
                    Text("ArtMuseum")
                    
                }.buttonStyle(DefaultButtonStyle())
                    .foregroundColor(Color.blue)
                    .padding()
                
            }
            .padding()
            .font(.system(size : 24))
        }
    }
}

struct Movie: View {
    var body: some View {
        ZStack{
            Text("Movie")
        }
      }
}


struct Book: View {
    var body: some View {
        Text("Book")
    }
}

struct ArtMuseum: View {
    var body: some View {
        Text("ArtMuseum")
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView()
        
    }
}


