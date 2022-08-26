//
//  AccessCoreData.swift
//  EmployeeManagement
//
//  Created by kai_oishi on 2022/08/16.
//

import Foundation
import CoreData
import UIKit

class AccessCoreData {
    static private let managedContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    static public func getStoredEmployee() -> [Employee]? {
        var employees:[Employee] = []
        let dataCondition = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
        
        do {
            employees = try managedContext.fetch(dataCondition) as! [Employee]
            return employees
        } catch {
            print("failed fetch stored employee info")
        }
        
        return nil
    }
    
    static public func storeEmployee(id: String, familyName: String, firstName: String, section: String, mail: String, gender: String) -> Bool {
        let newEmployee = Employee(context: managedContext)

        newEmployee.id = Int64(id.replacingOccurrences(of: "YZ", with: ""))!
        newEmployee.employee_id = id
        newEmployee.family_name = familyName
        newEmployee.first_name = firstName
        newEmployee.section_id = Int16(section)!
        newEmployee.mail = mail
        newEmployee.gender_id = Int16(gender)!
        
        guard var storedEmployees = getStoredEmployee() else { return  false }
        storedEmployees.append(newEmployee)
        return (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
}

extension Employee {
    func sectionName() -> String {
        switch self.section_id {
        case 1:
            return "シス開"
        case 2:
            return "グロカル"
        case 3:
            return "ビジソル"
        default:
            return "セクション名"
        }
    }
    
    func gender() -> String {
        switch self.section_id {
        case 1:
            return "男性"
        case 2:
            return "女性"
        default:
            return "性別"
        }
    }
}
