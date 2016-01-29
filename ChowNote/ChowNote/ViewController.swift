//
//  ViewController.swift
//  ChowNote
//
//  Created by Jason Chan MBP on 1/25/16.
//  Copyright © 2016 Jason Chan. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titleName: UITextField!
    
    
    @IBOutlet weak var bodyText: UITextField!
    
    
    var note: NoteEntity? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if note != nil {
            bodyText.text = note?.body
            titleName.text = note?.title
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelButton(sender: AnyObject) {
        
        
    navigationController!.popViewControllerAnimated(true)
        
        
    }
    
    
    @IBAction func saveButton(sender: AnyObject) {
        
        if note != nil {
            editNote()
        } else {
            createNote()
        }
        
    navigationController!.popViewControllerAnimated(true)
        
    
        
    }
    
    
    //create note method
    func createNote() {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        
        let newNote = NSEntityDescription.insertNewObjectForEntityForName("NoteEntity", inManagedObjectContext: context)
        newNote.setValue(titleName.text, forKey: "title")
        newNote.setValue(bodyText.text, forKey: "body")
        
        
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
                    let body = item.valueForKey("body")
                    
                    
                    print(title!, body!)
                    
                }
                
                
            }
            
            
        } catch{
            print("error reading data")
        }
        
        titleName.text = ""
        bodyText.text = ""
        
        
    }
    
    // edit note method
    
    func editNote() {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        note?.title = titleName.text!
        note?.body = bodyText.text!
    
       
        do {
            try context.save()
        } catch {
            
            print("error saving data")
        }
        
     
    }
    
// Mark: - Share button
    
    @IBAction func shareButton(sender: UIBarButtonItem) {
        
        let titleShare = "Title: \(titleName.text!)"
        
        let textToShare = "Note: \(bodyText.text!)"
        
            let objectsToShare = [titleShare, textToShare]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            self.presentViewController(activityVC, animated: true, completion: nil)
        
    
    }
    
// Mark: - dismiss keyboard
    
override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
       view.endEditing(true)
    super.touchesBegan(touches, withEvent: event)
    }

}

