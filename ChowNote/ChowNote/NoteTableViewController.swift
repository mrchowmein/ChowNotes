//
//  NoteTableViewController.swift
//  ChowNote
//
//  Created by Jason Chan MBP on 1/26/16.
//  Copyright © 2016 Jason Chan. All rights reserved.
//

import UIKit
import CoreData


class NoteTableViewController: UITableViewController, UISearchBarDelegate, NSFetchedResultsControllerDelegate {
    
    // Mark: - Properties
    @IBOutlet weak var searchBar: UISearchBar!

    let context = CoreDataStack.sharedInstance.managedObjectContext
    
//    lazy var context: NSManagedObjectContext = {
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        return appDelegate.managedObjectContext
//    }()
    
    // property for holding records
    var fetchedResultsController: NSFetchedResultsController!
    
    func fetchManagedObjects() {
        
        let fetchRequest = NSFetchRequest(entityName: "NoteEntity")
        let fetchSort = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [fetchSort]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            
        } catch let error as NSError {
            print("Unable to perform fetch: \(error.localizedDescription)")
        }
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchManagedObjects()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        
        guard let sectionCount = fetchedResultsController.sections?.count else {
            return 0
        }
        return sectionCount
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        guard let sectionData = fetchedResultsController.sections?[section] else {
            return 0
        }
        return sectionData.numberOfObjects
        
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //1
        let noteTitle = fetchedResultsController.objectAtIndexPath(indexPath) as! NoteEntity
        //2
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")!
        //3
        cell.textLabel!.text = noteTitle.valueForKey("title")as? String
        
        return cell
    }
    
    // MARK: -  FetchedResultsController Delegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        // 1
        switch type {
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        default: break
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        // 2
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        case .Update:
            tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        case .Move:
            tableView.reloadData()
            //default: break
        }
    }
   
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // 2
        switch editingStyle {
        case .Delete:
            let note = fetchedResultsController.objectAtIndexPath(indexPath) as! NoteEntity
            context.deleteObject(note)
            // 3
            do {
                try context.save()
            } catch let error as NSError {
                print("Error saving context after delete: \(error.localizedDescription)")
            }
        default:break
        }
    }
    
    // Mark: - Search
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.setShowsCancelButton(true, animated: true)
        
        if !searchText.isEmpty {
            
            fetchedResultsController = nil
            
            
            let fetchRequest = NSFetchRequest(entityName: "NoteEntity")
            
            fetchRequest.predicate = NSPredicate(format: "title contains[cd] %@", searchText)
            
            let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext:context,
                sectionNameKeyPath: nil, cacheName: nil)
            
            
            fetchedResultsController.delegate = self
            
        
            
            
            do {
                try fetchedResultsController.performFetch()
                
            } catch let error as NSError {
                print("Unable to perform fetch: \(error.localizedDescription)")
            }
            
            // Refresh the table view to show search results
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false // Hide the cancel
        searchBar.resignFirstResponder() // Hide the keyboard
        fetchManagedObjects()
        
        // Refresh the table view to show fetchedResultController results
        tableView.reloadData()
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "edit" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let noteControl:ViewController = segue.destinationViewController as! ViewController
            let note:NoteEntity = fetchedResultsController.objectAtIndexPath(indexPath!) as! NoteEntity
            noteControl.note = note
        }
    }
    
    
    
    
}
