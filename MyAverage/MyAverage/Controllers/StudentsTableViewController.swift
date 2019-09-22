//
//  StudentsTableViewController.swift
//  MyAverage
//
//  Created by Vitor Gomes on 25/08/19.
//  Copyright © 2019 Vitor Gomes. All rights reserved.
//

import UIKit
import CoreData

class StudentsTableViewController: UITableViewController {

    var fetchedResultController: NSFetchedResultsController<Student>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStudents()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "studentSegue" {
            let vc = segue.destination as! StudentsViewController
            
            if let students = fetchedResultController.fetchedObjects {
                vc.student = students[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
    
    // MARK: - Methods
    
    func loadStudents() {
        
        let fetchRequest: NSFetchRequest<Student> = Student.fetchRequest()
        let sortDescritor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescritor]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let count = fetchedResultController.fetchedObjects?.count ?? 0
        
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        guard let student = fetchedResultController.fetchedObjects?[indexPath.row] else {
            return cell
        }

        cell.textLabel?.text = "Aluno: \(student.name!)"
        cell.detailTextLabel?.text = "Media: \(student.average)"

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let student = fetchedResultController.fetchedObjects?[indexPath.row] else {return}
            context.delete(student)
            do { //-----------------
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension StudentsTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            case .delete:
                if let indexPath = indexPath {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                break
            default:
                tableView.reloadData()
        }
        
    }
}
