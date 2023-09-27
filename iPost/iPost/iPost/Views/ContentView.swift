//
//  ContentView.swift
//  iPost
//
//  Created by Albin Hashani on 9/26/23.
//

import Foundation
import SwiftUI
import CoreData


struct ContentView: View {
    @State private var isPresentingCreateView = false
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Post.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Post.date_created, ascending: false)]) var posts: FetchedResults<Post>
    
 
    var body: some View {
        NavigationView{
        VStack(alignment: .leading){
            Text("\(Int(totalPosts())) created").foregroundColor(.gray).padding(.horizontal)
            List {
                ForEach(posts) { post in
                    NavigationLink(destination: Text("\(post.title!)")){
                        HStack{
                            VStack(alignment: .leading, spacing: 6){
                                Text("\(post.post_description!)").bold()
                                
                                Text("\(post.author!) is feeling \(post.feeling!)").foregroundColor(.red)
                                
                            }
                            Spacer()
                            Text(calcTimeSince(date: post.date_created!)).foregroundColor(.gray).italic()
                            
                        }
                    }
                }.onDelete(perform: deletePost)
                
            }
            Button("Create new post"){
                isPresentingCreateView.toggle()
            }.sheet(isPresented: $isPresentingCreateView){
                CreatePostView(isPresented: $isPresentingCreateView)
            }
        }
        
        }.navigationTitle("iPost")
    }
  
    
    private func deletePost(offsets: IndexSet){
        
    }
    
    
    private func totalPosts() -> Int {
        return 5
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
