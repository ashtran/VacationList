//
//  ViewController.swift
//  TodoList
//
//  Created by ASHLEY TRAN on 11/14/17.
//  Copyright © 2017 ASHLEY TRAN. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    var tableData: [ToDoItem] = []
    
    
    // obtain context container //
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // share app delegate //
    let delegate = (UIApplication.shared.delegate as! AppDelegate)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var AddItemButton: UIBarButtonItem!
    
    @IBAction func AddItemButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ItemSegue", sender: AddItemButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableData = getItems()
        tableView.reloadData()
        
        // set up long press recognizer and action
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longPress))
        tableView.addGestureRecognizer(longPressRecognizer)
        
    }

    // Segue //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemSegue"{
            // set navigation controller as segue destination
            let navigationController = segue.destination as! UINavigationController
            
            // set add item controller to delegate
            let AddItemViewController = navigationController.topViewController as! AddItemViewController
            AddItemViewController.delegate = self
            
            
            // edit item and pass the following parameters to additemview controller
            if let indexPath = sender as? NSIndexPath{
                let item = tableData[indexPath.row]
                AddItemViewController.title = item.title
                AddItemViewController.desc = item.desc
                AddItemViewController.d = item.date!
                AddItemViewController.indexPath = indexPath
                AddItemViewController.alpha = 0
                
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func getItems() -> [ToDoItem] {
        do {
            // fetch items from data model //
            let itemRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoItem")
            
            // sort fetch items by date descending//
            let sectionsortDescriptors = NSSortDescriptor(key: "date", ascending:true)
            let sortDescriptors = [sectionsortDescriptors]
            itemRequest.sortDescriptors = sortDescriptors
            
            // fetch limit to 20 objects //
            itemRequest.fetchLimit = 5
            
            let results = try managedObjectContext.fetch(itemRequest)
            
            return results as! [ToDoItem]
        } catch{
            print(error)
        }
        return []
    }
    
    // function to perform when long press
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer){
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            let touchPoint = longPressGestureRecognizer.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint){
                performSegue(withIdentifier: "ItemSegue", sender: indexPath)
            }
        }
    }
    
    func cancelButtonPressed(by controller: AddItemViewController) {
        dismiss(animated: true, completion: nil)
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell (withIdentifier: "todoCell") as! todoCell
        let toDoItem = tableData[indexPath.row]
        
        let d = toDoItem.date!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "E, MMM dd, yyyy"
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat  = "h:mm a"
        
        let dateStr = dateFormatter.string(from: d)
        let dateStr2 = dateFormatter2.string(from: d)
        
        cell.titleLabel.text = toDoItem.title
        cell.dateLabel.text = dateStr + " \n@ " + dateStr2
        cell.descLabel.text = toDoItem.desc
        
        
        if toDoItem.complete {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableData[indexPath.row].complete{
            tableData[indexPath.row].complete = false
        } else {
            tableData[indexPath.row].complete = true
        }
        
        delegate.saveContext()
        tableData = getItems()
        tableView.reloadData()
    }
    
    
    // Remove item for row selected //
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // select item to be deleted //
        let item = tableData[indexPath.row]
        
        // delete from data model //
        managedObjectContext.delete(item)
        
        // try to save database after deletion //
        do{
            try managedObjectContext.save()
            
        }catch{
            print("\(error)")
        }
        
        // get most current table data //
        tableData = getItems()
        
        // reload table view data //
        tableView.reloadData()
    }
    
}


extension ViewController: AddItemDelegate{
    func itemSaved(_ title: String, _ desc: String, _ date: Date, at indexPath: NSIndexPath?, sender: UIViewController) {
        let ip = indexPath
        let item = tableData[(ip?.row)!]
        item.title = title
        item.desc = desc
        item.date = date
        item.complete = false
        delegate.saveContext()
        tableData = getItems()
        tableView.reloadData()
        sender.dismiss(animated:true, completion:nil)
    }
    
    func addItem(_ title: String, _ desc: String, _ date: Date, sender:UIViewController) {
        let item = NSEntityDescription.insertNewObject(forEntityName: "ToDoItem", into: managedObjectContext) as! ToDoItem
        item.title = title
        item.desc = desc
        item.date = date
        item.complete = false
        
        tableData.append(item)
        delegate.saveContext()
        tableData = getItems()
        tableView.reloadData()
        sender.dismiss(animated: true, completion: nil)
        
    }
}
