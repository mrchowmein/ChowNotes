//
//  ShareViewController.swift
//  ChowNoteShare
//
//  Created by Jason Chan MBP on 2/1/16.
//  Copyright © 2016 Jason Chan. All rights reserved.
//

import UIKit
import Social
import CoreData

class ShareViewController: SLComposeServiceViewController {

    
    override func isContentValid() -> Bool {
        
        if contentText.isEmpty {
            return false
        } else {
            
            return true
        }
        
        // Do validation of contentText and/or NSExtensionContext attachments here
       
    }

    override func didSelectPost() {
        self.createNote()
        
    }

    override func configurationItems() -> [AnyObject]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }
    
    
    func createNote() {
        //        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //        let context: NSManagedObjectContext = appDel.managedObjectContext
        //
        
        let context = CoreDataStack.sharedInstance.managedObjectContext

        let newNote = NSEntityDescription.insertNewObjectForEntityForName("NoteEntity", inManagedObjectContext: context)
        newNote.setValue(self.contentText, forKey: "title")
        
//        if let content = extensionContext!.inputItems[0] as? [NSItemProvider] {
//            let contentType = ku
//            
//        }
//        
//        
//    
        
        do {
            try context.save()
        } catch{
            print("error saving data")
        }
        
        //retrive note
        do {
            let request = NSFetchRequest(entityName: "NoteEntity")
            let results = try context.executeFetchRequest(request)
            
            if results.count > 0 {
                
                for item in results as! [NSManagedObject]{
                    
                    let title = item.valueForKey("title")
                    //let body = item.valueForKey("body")
                    
                    
                    print(title!)
                    
                }
                
                
            }
            
            
        } catch{
            print("error reading data")
        }
        
       
        
        
    }

}
