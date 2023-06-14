import SwiftUI
import Foundation

struct RegView: View {
    @State private var newid : String = ""
    @State private var newpw : String = ""
    @State private var conpw : String = ""
    @State private var idAlert : Bool = false
    @State private var pwAlert : Bool = false
    @State private var notAlert : Bool = false
    @State private var getUser : Bool = false
    var body: some View {
        ZStack{
            Text("아이디")
                .offset(x:-165,y:-100)
                .font(.system(size: 20, weight: .light))
                .foregroundColor(Color.black)
            TextField("Enter Your Id",text: $newid)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300,height: 10)
                .offset(x:-35,y:-55)
            Button{
                idAlert = true;
            } label:{
                Text("확인")
            }.offset(x:150,y:-55)
            .alert("메시지", isPresented: $idAlert){
                Button("확인"){}
            }message: {
                Text("아이디가 확인 되었습니다.")
            }
            
            Text("비밀번호")
                .offset(x:-155,y:10)
                .font(.system(size: 20, weight: .light))
                .foregroundColor(Color.black)
            SecureField("Enter Your Password",text: $newpw)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300,height: 10)
                .offset(x:-35,y:55)
            
            Text("비밀번호 확인")
                .offset(x:-135,y:120)
                .font(.system(size: 20, weight: .light))
                .foregroundColor(Color.black)
            SecureField("Confirm Your Password",text: $conpw)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300,height: 10)
                .offset(x:-35,y:165)
            Button{
                if newpw.elementsEqual(conpw){
                    pwAlert = true
                }
                else{
                    notAlert = true
                }
            } label:{
                Text("확인")
            }.offset(x:150,y:165)
            .alert("메시지", isPresented: $pwAlert){
                Button("확인"){}
            }message: {
                Text("비밀번호가 확인되었습니다.")
            }
            .alert("메시지", isPresented: $notAlert){
                Button("확인"){}
            }message: {
                Text("비밀번호를 다시 확인해주세요.")
            }
            
           
        }
        .padding()
        
        
    }
   
    
}


class CofirmUser:UserDefaults{
    
}
struct RegView_Previews: PreviewProvider {
    static var previews: some View {
        RegView()
    }
}
