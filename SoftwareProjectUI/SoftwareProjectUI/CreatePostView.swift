//
//  CreatePostView.swift
//  SoftwareProjectUI
//
//  Created by 서영석 on 2023/05/09.
//

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
               NavigationLink(destination: Movie()){
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
            Text("ㅎㅎ")
        }
      }
}


struct Book: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ArtMuseum: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView()
        
    }
}


