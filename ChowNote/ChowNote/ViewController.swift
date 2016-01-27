//
//  ViewController.swift
//  ChowNote
//
//  Created by Jason Chan MBP on 1/25/16.
//  Copyright © 2016 Jason Chan. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var titleName: UITextField!
    
    
    @IBOutlet weak var bodyText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelButton(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func saveButton(sender: AnyObject) {
       
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        //add note
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
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }

}

