//
//  CreatePostView.swift
//  iPost
//
//  Created by Albin Hashani on 9/26/23.
//

import SwiftUI

struct CreatePostView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var author = ""
    @State private var title = ""
    @State private var post_description = ""
    @State private var selectedFeelingIndex = 0
    @Binding var isPresentedView: Bool
    @Binding var showCreatePostAlert: Bool

    let emotions = ["Happy", "Sad", "Angry", "Excited", "Calm", "Tired", "Surprised", "Loved"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $title)
                    TextField("Body", text: $post_description)
                    TextField("Author", text: $author)
                    
                    VStack {
                        Text("How are you feeling?")
                        Picker("Feeling", selection: $selectedFeelingIndex) {
                            ForEach(0..<emotions.count, id: \.self) { index in
                                Text(emotions[index]).tag(index)
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                    
                    VStack {
                        Slider(value: Binding(
                            get: { Double(selectedFeelingIndex) },
                            set: { newValue in selectedFeelingIndex = Int(newValue) }
                        ), in: 0.0...(Double(emotions.count - 1)))
                        .padding(.horizontal)
                        .accentColor(Color(emotions[selectedFeelingIndex]))
                        Text("\(emotions[selectedFeelingIndex])")
                    }
                
                    
                HStack{
                        Button("Create"){
                            DataController().addPost(author: author, title: title, post_description: post_description, feeling: emotions[selectedFeelingIndex], context: managedObjectContext)
                                showCreatePostAlert = true
                }
            }.navigationBarItems(
                leading: Button("Cancel") {
                    isPresentedView.toggle()
                },
                trailing: EmptyView()
            )
            .navigationTitle("New post")
            }
        }
        .alert(isPresented: $showCreatePostAlert) {
            Alert(
                title: Text("Post Created"),
                message: Text("Your post has been created successfully."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
}
