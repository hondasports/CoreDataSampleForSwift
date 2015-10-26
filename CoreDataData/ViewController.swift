//
//  ViewController.swift
//  CoreDataData
//
//  Created by tatsuya on 2015/10/24.
//  Copyright © 2015年 MIYAMOTO TATSUYA. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var obj : NSManagedObject? = nil
    
    @IBOutlet weak var memoLoad: UITextField!
    @IBOutlet weak var memoCreate: UITextField!
    @IBOutlet weak var memoUpdate: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // Save
    @IBAction func save(sender: UIButton) {
        if( (memoCreate.text?.isEmpty) == true){
            print("Text does not have any string")
            return
        }
        
        // Get ManagedObjectContext
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext : NSManagedObjectContext = appDelegate.managedObjectContext
        
        // Create new Manage Object
        var newTodo = NSEntityDescription.insertNewObjectForEntityForName("Memo", inManagedObjectContext: managedContext) as NSManagedObject
        newTodo.setValue(memoCreate.text, forKey: "memo")
        
        // Save & Error handling
        do{
            try managedContext.save()
        } catch let error as NSError? {
            print("Could not save \(error)")
        }
        print(newTodo)
        print("object has been saved")
        
    }
    
    // Load
    @IBAction func loadl(sender: UIButton) {
        if( memoLoad.text?.isEmpty == true){
            print( "Load text does not have any string")
            return
        }
        
        // Get ManagedObjectContext
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext : NSManagedObjectContext = appDelegate.managedObjectContext
        
        // Set search condition
        let fetchRequest = NSFetchRequest(entityName : "Memo")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "memo = %@", memoLoad.text!)
        
        // Get result
        do{
            var fetchResults : Array? = try managedContext.executeFetchRequest(fetchRequest)
            if(fetchResults?.count > 0){
                obj = fetchResults?[0] as? NSManagedObject
                let memo : String = obj!.valueForKey("memo") as! String
                memoLoad.text = memo
                print(obj)
            } else {
                memoLoad.text = "Does not match result"
            }
        } catch let error as NSError? {
            print ("error has happended")
        }
    }
    
    // Update
    @IBAction func update(sender: UIButton) {
        
        // Get ManagedObjectContext
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext : NSManagedObjectContext = appDelegate.managedObjectContext
        
        if(obj == nil){
            print("does not have any string")
        } else{
            
            
            obj?.setValue(memoUpdate.text, forKey: "memo")
            
            do {
                try managedContext.save()
                print("item has been updated")
            } catch let error as NSError?{
                print("did not update text \(error)")
            }
            
        }
    }
}