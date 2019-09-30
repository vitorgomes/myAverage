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
    var subjectsManager = SubjectsManager.shared
    var subjectManagerSet: NSSet = []
    
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
        subjectsManager.loadSubject(with: context)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tvSubjects.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func showAlert(with subject: Subject?) { //---------------999999999999999999999
        let alert = UIAlertController(title: "Nota", message: nil, preferredStyle: .alert)
        alert.addTextField { (textfield) in
            if let grade = self.student?.grade {
                textfield.text = String(grade)
            }
        }
        alert.addAction(UIAlertAction(title: "Adcionar/Editar", style: .default, handler: { (actions) in
            let subject = subject ?? Subject(context: self.context)
            subject.name = alert.textFields?.first?.text
            do {
                try self.context.save()
                self.subjectsManager.loadSubject(with: self.context)
                self.tvSubjects.reloadData()
            } catch {
                print(error.localizedDescription)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func addEditStudent(_ sender: UIButton) {
        if student == nil {
            student = Student(context: context)
        }
        
        //subjectManagerSet = [subjectsManager.subjects] // ta vindo 0, nao sei o porque
        
        //student.registeredSubjects =  // -----------relacao das notas com subject
        
        subjectManagerSet.addingObjects(from: subjectsManager.subjects)
        
        student.name = tfName.text
        student.email = tfEmail.text
        student.registeredSubjects = subjectManagerSet
        
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return student.registeredSubjects?.count ?? 0//subjectsManager.subjects.count // errado 00000000000
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //-------------
        
        
        
        //------------
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //cell.textLabel?.text = "Materia: \(student.registeredSubjects)"
        //cell.textLabel?.text = "Materia: \(student.registeredSubjects)"
         //\(subjectsManager.subjects[indexPath.row].name!)
        //cell.detailTextLabel?.text = "Nota: \(subjectsManager.subjects[indexPath.row].grade)"
        
        let subjects = subjectsManager.subjects[indexPath.row] //-----------9999999
        showAlert(with: subjects) //---------- 9999999
        
        return cell
    }
}

extension StudentsViewController: UITableViewDelegate {
    
}
