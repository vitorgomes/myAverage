//
//  SubjectsManager.swift
//  MyAverage
//
//  Created by Vitor Gomes on 08/09/19.
//  Copyright © 2019 Vitor Gomes. All rights reserved.
//

import Foundation
import CoreData

class SubjectsManager {
    static let shared = SubjectsManager()
    var subjects: [Subject] = []
    
    func loadSubject(with context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Subject> = Subject.fetchRequest()
        let sortDescritor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescritor]
        
        do {
            subjects = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteSubject(index: Int, context: NSManagedObjectContext) {
        let subject = subjects[index]
        context.delete(subject)
        
        do {
            try context.save()
            subjects.remove(at: index)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private init() {
        
    }
}
