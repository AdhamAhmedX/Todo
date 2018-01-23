//
//  CategoryTableViewController.swift
//  Todo
//
//  Created by Adhoom ahmed on 1/16/18.
//  Copyright © 2018 Adhoom ahmed. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
   
    let realm = try! Realm()
    var categoryArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    // Mark: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return categoryArray?.count ?? 1
        }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
 cell.textLabel?.text = categoryArray?[indexPath.row].titlee ?? "No Categories Added Yet"
     
        return cell
        
        
        
    }
    //Mark: - TableView Delgate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    //Mark: - Data Manipulation Methods
    func save(category:Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error Saving Category \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories() {
       categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    
    
    //Mark: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.titlee = textField.text!
            
            
            
            self.save(category: newCategory)
            
        }
        alert .addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Create New Category"
         
        }
        present (alert, animated: true, completion: nil)
    }
}
