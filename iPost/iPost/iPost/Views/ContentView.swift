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
    @State private var isPresentingEditView = false
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Post.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Post.date_created, ascending: false)]) var posts: FetchedResults<Post>
    
 
    var body: some View {
        NavigationView{
        VStack(alignment: .leading){
            Text("\(Int(totalPosts())) created").foregroundColor(.gray).padding(.horizontal)
            List {
                ForEach(posts) { post in
                    NavigationLink(destination: EditPostView(managedObjectContext: _managedObjectContext, post: post, isPresented: $isPresentingEditView )){
                        HStack{
                            VStack(alignment: .leading, spacing: 6){
                                Text("\(post.title!)").bold()
                                Text("\(post.post_description!)").italic()
                                
                                if post.feeling == "Happy" || post.feeling == "Excited" {
                                    Text("\(post.author!) is feeling \(post.feeling!)").foregroundColor(.green)
                                }else if post.feeling == "Sad" || post.feeling == "Angry"{
                                    Text("\(post.author!) is feeling \(post.feeling!)").foregroundColor(.red)
                                }else {
                                    Text("\(post.author!) is feeling \(post.feeling!)")         }
                            }
                            Spacer()
                            Text(calcTimeSince(date: post.date_created!)).foregroundColor(.gray).italic()
                            
                        }
                    }
                }.onDelete(perform: deletePost)
                
            }
         
        }
 
        .navigationTitle("iPost")
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Button{
                    isPresentingCreateView = true
                } label: {
                    Label("Create post", systemImage: "plus.circle")
                }.sheet(isPresented: $isPresentingCreateView){
                    CreatePostView(isPresented: $isPresentingCreateView)
                }}
            ToolbarItem(placement: .navigationBarLeading){
                EditButton()
            }
        }
            
        }
        
        
    }
  
    
    private func deletePost(offsets: IndexSet){
        withAnimation{
            offsets.map { posts[$0] }.forEach(managedObjectContext.delete)
            
            DataController().save(context: managedObjectContext)
        }
    }
    
    
    private func totalPosts() -> Int {
        return posts.count
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
