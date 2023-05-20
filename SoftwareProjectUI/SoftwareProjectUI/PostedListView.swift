//
//  PostedListView.swift
//  SoftwareProjectUI
//
//  Created by 서영석 on 2023/05/09.
//

import SwiftUI

struct PostedListView: View {
    var body: some View {
        VStack{
            Text("Posted List")
                .font(.largeTitle)
                .fontWeight(.medium)
                .offset(x:0, y:-250)
            VStack{
                NavigationLink(destination: Movie()){
                    Text("Movie")
                    
                }
                .buttonStyle(DefaultButtonStyle())
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
                
            }.padding()
        }
    }
}

struct MovieList: View {
    var body: some View {
        Text("Movie List")
    }
}

struct BookList: View {
    var body: some View {
        Text("Book List")
    }
}

struct ArtMuseumList: View {
    var body: some View {
        Text("ArtMuseum List")
    }
}

struct PostedListView_Previews: PreviewProvider {
    static var previews: some View {
        PostedListView()
    }
}
