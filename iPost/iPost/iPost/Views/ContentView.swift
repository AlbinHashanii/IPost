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
    @State private var createPostAlert = false // Add this @State variable
    
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
                        NavigationLink(destination: EditPostView(managedObjectContext: _managedObjectContext, post: post, isPresentedEdit: $isPresentingEditView)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("\(post.title!)").bold()
                                    Text("\(post.post_description!)").italic()
                                    
                                    if post.feeling == "Happy" || post.feeling == "Excited" {
                                        Text("\(post.author!) is feeling \(post.feeling!)").foregroundColor(.green)
                                    } else if post.feeling == "Sad" || post.feeling == "Angry" {
                                        Text("\(post.author!) is feeling \(post.feeling!)").foregroundColor(.red)
                                    } else {
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
                    isPresentingCreateView.toggle()
                }) {
                    Label("Create Post", systemImage: "plus.circle")
                        .font(.title2)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .sheet(isPresented: $isPresentingCreateView) {
                    CreatePostView(
                        isPresentedView: $isPresentingCreateView)
                }
                .padding()
                
            }
            .navigationBarTitle("iPost", displayMode: .automatic)
            .navigationBarItems(
                leading: EditButton()
            )
            .alert(isPresented: $createPostAlert) {
                Alert(
                    title: Text("Post created"),
                    message: Text("Post posted successfully"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func deletePost(offsets: IndexSet) {
        withAnimation {
            offsets.map { posts[$0] }.forEach(managedObjectContext.delete)
            DataController().save(context: managedObjectContext)
        }
    }
    
    private func totalPosts() -> Int {
        return posts.count
    }
}
