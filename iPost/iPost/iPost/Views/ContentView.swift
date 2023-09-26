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
    
    @State private var posts: [Post] = []
    var body: some View {
        NavigationView{
        VStack(alignment: .leading){
            Text("\(Int(totalPosts())) created").foregroundColor(.gray).padding(.horizontal)
            List {
                ForEach(posts) { post in
                    NavigationLink(destination: Text("\(post.title)")){
                        HStack{
                            VStack(alignment: .leading, spacing: 6){
                                Text(post.post_description).bold()
                            }
                            
                        }
                    }
                }
            }
            Button("Create new post"){
                isPresentingCreateView.toggle()
            }.sheet(isPresented: $isPresentingCreateView){
                CreatePostView(isPresented: $isPresentingCreateView)
            }
        }
        }.navigationTitle("iPost")
    }
    
    private func fetchData(){
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
    
        do {
            self.posts = try managedObjectContext.fetch(fetchRequest)
            if let firstPost = posts.first {
            }
        }catch{
            
        }
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
