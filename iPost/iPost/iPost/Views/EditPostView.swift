//
//  EditPostView.swift
//  iPost
//
//  Created by Albin Hashani on 9/27/23.
//
import SwiftUI
import CoreData

struct EditPostView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var post: Post
    
    @Binding var isPresentedEdit: Bool
    
    @State private var title = ""
    @State private var post_description = ""
    @State private var selectedFeelingIndex = 0
    
    let emotions = ["Happy", "Sad", "Angry", "Excited", "Calm", "Tired", "Surprised", "Loved"]
    
    var body: some View {
        Form {
            Section {
                TextField("\(post.title!)", text: $title)
                    .onAppear {
                        title = post.title!
                    }
                TextField("\(post.post_description!)", text: $post_description)
                    .onAppear {
                        post_description = post.post_description!
                    }
            
                VStack{
                    Text("How are you feeling?")
                    Picker("Feeling", selection: $selectedFeelingIndex) {
                        ForEach(0..<emotions.count, id: \.self) { index in
                            Text(emotions[index]).tag(index)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    Slider(value: Binding(
                        get: { Double(selectedFeelingIndex) },
                        set: { newValue in selectedFeelingIndex = Int(newValue) }
                    ), in: 0.0...(Double(emotions.count - 1)), step: 1.0)
                    .padding(.horizontal)
                    .accentColor(Color(emotions[Int(selectedFeelingIndex)]))
                    
                    Text("\(emotions[selectedFeelingIndex])")
                }.padding()
                
                HStack {
                    Spacer()
                    Button("Submit"){
                        DataController().editPost(post: post, title: title, post_description: post_description, feeling: emotions[selectedFeelingIndex], context: managedObjectContext)
                        
                        // Set the alert message here
                        isPresentedEdit = false
                        // Set the alert message here
                    }
                    Spacer()
                }
            }
        }
    }
}
