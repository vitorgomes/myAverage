//
//  SubjectsTableViewController.swift
//  MyAverage
//
//  Created by Vitor Gomes on 07/09/19.
//  Copyright © 2019 Vitor Gomes. All rights reserved.
//

import UIKit

class SubjectsTableViewController: UITableViewController {

    var subjectsManager = SubjectsManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if subjectsManager.subjects.isEmpty { //-----------
        } else {
            loadSubjects()
        }
    }
    
    func loadSubjects() {
        subjectsManager.loadSubject(with: context)
        tableView.reloadData()
    }
    
    func showAlert(with subject: Subject?) {
        let title = subject == nil ? "Adicionar" : "Editar"
        let alert = UIAlertController(title: title + " materia", message: nil, preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Nome da materia"
            if let name = subject?.name {
                textfield.text = name
            }
        }
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { (actions) in
            let subject = subject ?? Subject(context: self.context)
            subject.name = alert.textFields?.first?.text
            do {
                try self.context.save()
                self.loadSubjects()
            } catch {
                print(error.localizedDescription)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addSubject(_ sender: UIBarButtonItem) {
        showAlert(with: nil)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return subjectsManager.subjects.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let subjects = subjectsManager.subjects[indexPath.row]
        showAlert(with: subjects)
        tableView.deselectRow(at: indexPath, animated: false)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let subject = subjectsManager.subjects[indexPath.row]
        cell.textLabel?.text = subject.name

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            subjectsManager.deleteSubject(index: indexPath.row, context: context)
            tableView.deleteRows(at: [indexPath], with: .fade)
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
