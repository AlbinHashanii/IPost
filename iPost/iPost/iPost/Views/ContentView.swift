//
//  ContentView.swift
//  iPost
//
//  Created by Albin Hashani on 9/26/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var isPresentingCreateView = false
    @State private var isPresentingEditView = false
    @State private var createPostAlert = false
    @State private var isCreatingPost = false
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Post.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Post.date_created, ascending: false)]) var posts: FetchedResults<Post>
    
    var body: some View {
        NavigationView {
            VStack {
                Text("\(Int(totalPosts())) created")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                List {
                    ForEach(posts) { post in
                        NavigationLink(destination: EditPostView(managedObjectContext: _managedObjectContext, post: post, isPresentedEdit: $isPresentingEditView, showEditPostAlert: $createPostAlert)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("\(post.title!)").bold()
                                    Text("\(post.post_description!)").italic()
                                    
                                    if post.feeling == "Happy" || post.feeling == "Excited" {
                                        Text("\(post.author!) is feeling \(post.feeling!)").foregroundColor(.green)
                                    } else if post.feeling == "Sad" || post.feeling == "Angry" {
                                        Text("\(post.author!) is feeling \(post.feeling!)").foregroundColor(.red)
                                    } else if post.feeling == "Calm" || post.feeling == "Tired" {
                                        Text("\(post.author!) is feeling \(post.feeling!)").foregroundColor(.yellow)
                                    }else if post.feeling == "Surprised" || post.feeling == "Loved" {
                                        Text("\(post.author!) is feeling \(post.feeling!)").foregroundColor(.pink)
                                    }
                                    else {
                                        Text("\(post.author!) is feeling \(post.feeling!)")
                                    }
                                }
                                Spacer()
                                Text(calcTimeSince(date: post.date_created!))
                                    .foregroundColor(.gray)
                                    .italic()
                            }
                        }
                    }
                    .onDelete(perform: deletePost)
                }
                .listStyle(PlainListStyle())
                
                Button(action: {
                    isCreatingPost.toggle()
                }) {
                    Label("Create Post", systemImage: "plus.circle")
                        .font(.title2)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .sheet(isPresented: $isCreatingPost) {
                    CreatePostView(isPresentedView: $isCreatingPost, showCreatePostAlert: $createPostAlert)
                        .environment(\.managedObjectContext, managedObjectContext)
                }
                .padding()
            }
            .navigationBarTitle("iPost", displayMode: .automatic)
            .navigationBarItems(
                leading: EditButton()
            )
        }
        .alert(isPresented: $createPostAlert) {
            Alert(
                title: Text("Post Created"),
                message: Text("Your post has been created successfully."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func deletePost(offsets: IndexSet) {
        withAnimation {
            offsets.map { posts[$0] }.forEach { post in
                managedObjectContext.delete(post)
            }
            do {
                try managedObjectContext.save()
            } catch {
                print("Error deleting post: \(error)")
            }
        }
    }
    
    private func totalPosts() -> Int {
        return posts.count
    }
}
