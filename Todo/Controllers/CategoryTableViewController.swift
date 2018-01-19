//
//  CategoryTableViewController.swift
//  Todo
//
//  Created by Adhoom ahmed on 1/16/18.
//  Copyright © 2018 Adhoom ahmed. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories() 
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    // Mark: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return categoryArray.count
        }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
 cell.textLabel?.text = categoryArray[indexPath.row].titlee
     
        return cell
        
        
        
    }
    //Mark: - TableView Delgate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //Mark: - Data Manipulation Methods
    func saveCategory() {
        do {
            try context.save()
        } catch {
            print("Error Saving Category \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error Loading \(error)")
            
        }
        tableView.reloadData()
    }
    
    
    
    //Mark: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context:self.context)
            newCategory.titlee = textField.text!
            
               self.categoryArray.append(newCategory)
            
            self.saveCategory()
            
            self.tableView.reloadData()
        }
        alert .addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Create New Category"
         
        }
        present (alert, animated: true, completion: nil)
    }
}
