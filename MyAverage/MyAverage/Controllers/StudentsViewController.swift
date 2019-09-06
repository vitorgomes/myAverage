//
//  StudentsViewController.swift
//  MyAverage
//
//  Created by Vitor Gomes on 25/08/19.
//  Copyright © 2019 Vitor Gomes. All rights reserved.
//

import UIKit
import CoreData

class StudentsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfSubjectName: UITextField!
    @IBOutlet weak var tfGrade: UITextField!
    @IBOutlet weak var lbAverage: UILabel!
    @IBOutlet weak var tvSubjects: UITableView!
    @IBOutlet weak var lbTableTittle: UILabel!
    
    // MARK: - Variables and Constants
    
    var student: Student!
    var subject: Subject!
    var fetchedResultController: NSFetchedResultsController<Subject>! //-------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let student = student {
            navigationItem.title = student.name
            tfName.text = student.name
            tfEmail.text = student.email
            lbTableTittle.text = "Lista de Materias de \(student.name!)"
        } else {
            navigationItem.title = "Novo(a) Aluno(a)"
        }
        loadSubjects() //------------------------
    }
    
    func loadSubjects() { //-----------------------
        
        let fetchRequest: NSFetchRequest<Subject> = Subject.fetchRequest()
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Actions
    
    @IBAction func addEditSubject(_ sender: UIButton) {
        if subject == nil {
            subject = Subject(context: context)
        }
        
        subject.name = tfSubjectName.text
        if let grade = Double(tfGrade.text!) {
            subject.grade = grade
        } else {
            subject.grade = 0.0
        }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func addEditStudent(_ sender: UIButton) {
        if student == nil {
            student = Student(context: context)
        }
        
        student.name = tfName.text
        student.email = tfEmail.text
        if let average = Double(lbAverage.text!) {
           student.average = average
        } else {
            student.average = 0.0
        }
        
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
}

extension StudentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //---------------
        let count = fetchedResultController.fetchedObjects?.count ?? 0
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //-------------
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        guard let subject = fetchedResultController.fetchedObjects?[indexPath.row] else {
            return cell
        }
        
        cell.textLabel?.text = "Materia: \(subject.name!)"
        cell.detailTextLabel?.text = "Nota: \(subject.grade)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let subject = fetchedResultController.fetchedObjects?[indexPath.row] else {return}
            context.delete(subject)
            do { // ----------------------
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension StudentsViewController: UITableViewDelegate {
    
}

extension StudentsViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            case .delete:
                if let indexPath = indexPath {
                    tvSubjects.deleteRows(at: [indexPath], with: .fade)
                }
                break
            default:
                tvSubjects.reloadData()
        }
    }
}
