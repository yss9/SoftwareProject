import SwiftUI

struct CreateUIView: View {
    @State var title = ""
    @State var director = ""
    @State var actor = ""
    @State var score = ""
    @State var reviews = ""
    
    
    var body: some View {
        
        ZStack{
            Label("Movie", systemImage:"popcorn")
                .font(.system(size: 40, weight: .light))
                .offset(x:-10,y:-360)
                .foregroundColor(Color(hue: 1.0, saturation: 0.739, brightness: 0.27))
            Text("제목")
                .offset(x:-170,y:-305)
                .font(.system(size: 20, weight: .light))
            TextField("입력하세요",text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 330,height: 10)
                .offset(x:20,y:-305)
            
            Text("감독")
                .offset(x:-170,y:-265)
                .font(.system(size: 20, weight: .light))
            TextField("입력하세요",text: $director)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 330,height: 10)
                .offset(x:20,y:-265)
            
            Text("배우")
                .offset(x:-170,y:-225)
                .font(.system(size: 20, weight: .light))
            TextField("입력하세요",text: $actor)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 330,height: 10)
                .offset(x:20,y:-225)
            
            Text("별점")
                .offset(x:-170,y:-180)
                .font(.system(size: 20, weight: .light))
            TextField("입력하세요",text: $score)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 330,height: 10)
                .offset(x:20,y:-180)
            
            TextEditor(text: $reviews)
                  .cornerRadius(30)
                  .padding()
                  .background(.gray)
                  .textFieldStyle(RoundedBorderTextFieldStyle())
                  .frame(width: 400,height: 280)
                  .offset(x:0,y:270)
            
        }.padding()
    }
    
}



struct CreateUIView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUIView()
    }
}

struct CreateMovie{
    var title : String = ""
    var director : String = ""
    var actor : String = ""
    var score : String = ""
    var reviews : String = ""
    
    init(title: String, director: String, actor: String, score: String, reviews: String) {
        self.title = title
        self.director = director
        self.actor = actor
        self.score = score
        self.reviews = reviews
    }
    
}

struct CreateBook:Identifiable{
    let id: UUID
    var title : String
    
}
