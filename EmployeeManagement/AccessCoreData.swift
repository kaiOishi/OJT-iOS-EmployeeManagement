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
    
    static public func storeEmployee(newEmployeeInfo: EmployeeInfo) {
        let newEmployee = Employee(context: managedContext)

        newEmployee.id = newEmployeeInfo.id
        newEmployee.employee_id = newEmployeeInfo.employeeId
        newEmployee.family_name = newEmployeeInfo.familyName
        newEmployee.first_name = newEmployeeInfo.firstName
        newEmployee.section_id = Int16(newEmployeeInfo.sectionId)
        newEmployee.mail = newEmployeeInfo.mail
        newEmployee.gender_id = Int16(newEmployeeInfo.genderId)
        
        guard var storedEmployees = getStoredEmployee() else { return }
        
        storedEmployees.append(newEmployee)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
}
