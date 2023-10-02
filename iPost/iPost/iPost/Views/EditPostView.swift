//
//  EditPostView.swift
//  iPost
//
//  Created by Albin Hashani on 10/2/23.
//

import SwiftUI

struct EditPostView: View {
    @Environment (\.managedObjectContext) var managedObjectContext
    
    var post: Post
    
    @Binding var isPresentedEdit: Bool
    
    @State private var title = ""
    @State private var post_description = ""
    @State private var feeling = "Happy"
    @State private var feelingD: Double = 0.0
    let emotions = ["Happy", "Sad", "Angry", "Excited", "Calm", "Tired"]
    
    
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
                    Text("Feeling:  \(currentEmotion())")
                    Slider(value: $feelingD, in: 0...100, step: 15)
                    Text("\(currentEmotion())")
                }.padding()
                
                HStack {
                    Spacer()
                    Button("Submit"){
                        DataController().editPost(post: post, title: title, post_description: post_description, feeling: feeling, context: managedObjectContext)
                    }
                    Spacer()
                }
                
                
            }
        }
    
    
    }
    
    func currentEmotion() -> String {
        switch Int(feelingD) {
        case 0..<20:
           return emotions[0]
        case 20..<40:
            return emotions[1]
        case 40..<60:
            return emotions[2]
        case 60..<80:
            return emotions[3]
        default:
            return emotions[4]
        }
    }
    
}
