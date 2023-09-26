//
//  DataController.swift
//  iPost
//
//  Created by Albin Hashani on 9/26/23.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "PostModel")
    
    init(){
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("Failed to load the posts \(error.localizedDescription)")
            }
        }
        
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Post has been saved (:")
        }catch{
            print("Post couldn't be saved ):")
        }
    }
    
    func addPost(author: String, title: String, post_description: String, feeling: String,context: NSManagedObjectContext){
        let post = Post(context: context)
        post.id = UUID()
        post.date_created = Date()
        post.author = author
        post.title = title
        post.post_description = post_description
        post.feeling = feeling
        post.date_edited = nil
        
        save(context: context)
    }
    
    func editPost(post: Post,title: String,post_description: String,feeling: String, context: NSManagedObjectContext){
        post.title = title
        post.post_description = post_description
        post.feeling = feeling
        post.date_edited = Date()
        
        save(context: context)
    }
}
