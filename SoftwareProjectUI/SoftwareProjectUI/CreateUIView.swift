//
//  CreateUIView.swift
//  SoftwareProjectUI
//
//  Created by 서영석 on 2023/05/14.
//

import SwiftUI

struct CreateUIView: View {
    @State var title = ""
    @State var director = ""
    @State var actor = ""
    var scores = [0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0,1.0,1.1,1.2,1.3,1.4,1.5,1.6,1.7,1.8,1.9,2.0,2.1,2.2,2.3,2.4,2.5,2.6,2.7,2.8,2.9,3.0,3.1,3.2,3.3,3.4,3.5,3.6,3.7,3.8,3.9,4.0,4.1,4.2,4.3,4.4,4.5,4.6,4.7,4.8,4.9,5.0,]
    @State var score : Float = 0.0
    var body: some View {
        
        ZStack{
            Label("Movie", systemImage:"popcorn")
                .font(.system(size: 40, weight: .light))
                .offset(x:-10,y:-360)
                .foregroundColor(Color(hue: 1.0, saturation: 0.739, brightness: 0.27))
            Text("제목")
                .offset(x:-170,y:-305)
                .font(.system(size: 20, weight: .light))
            TextField("",text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 330,height: 10)
                .offset(x:20,y:-305)
            
            Text("감독")
                .offset(x:-170,y:-265)
                .font(.system(size: 20, weight: .light))
            TextField("",text: $director)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 330,height: 10)
                .offset(x:20,y:-265)
            
            Text("배우")
                .offset(x:-170,y:-225)
                .font(.system(size: 20, weight: .light))
            TextField("",text: $actor)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 330,height: 10)
                .offset(x:20,y:-225)
            
            Text("별점")
                .offset(x:-170,y:-180)
                .font(.system(size: 20, weight: .light))
            
        }.padding()
    }
}



struct CreateUIView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUIView()
    }
}

struct CreateMovie:Identifiable{
    let id: UUID
    var title : String
    var director : String
    var actor : String
    var score : Float
    
}

struct CreateBook:Identifiable{
    let id: UUID
    var title : String
    
}
