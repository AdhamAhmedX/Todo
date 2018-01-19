//
//  ViewController.swift
//  Todo
//
//  Created by Adhoom ahmed on 1/10/18.
//  Copyright © 2018 Adhoom ahmed. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
  
    }
//    Mark -TableView Delegate Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
    cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
    return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // if I want to delete:
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
         itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()
        
        
       
        tableView.deselectRow(at: indexPath, animated: true)
    }
//    Mark- Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item" ,message: "" ,preferredStyle: .alert)
        let action = UIAlertAction(title:"Add Item" , style: .default) {(action) in
            // What will happen once the user clicks the Add Item button on our UIAlert
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems()
            
      
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
}
    // Mark - Model Manupulation Methods
    func saveItems() {
    
        do {
            try context.save()
            
        } catch {
            print("Error saving context , \(error)")
        }
        self.tableView.reloadData()
    }
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest(),predicate:NSPredicate? = nil) {
        let categoryPredicate = NSPredicate (format: "parentCategory.titlee MATCHES %@",selectedCategory!.titlee!)
        if let addionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,addionalPredicate])
            
        } else {
            request.predicate = categoryPredicate
        }

        do{
      // let request : NSFetchRequest<Item> = Item.fetchRequest()
      itemArray = try context.fetch(request)
        } catch{
            print("Error fetching data fron context \(error)")
        }
    }
    
}
// Mark- Search Bar methodees
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
    }
    }
    
}