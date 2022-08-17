//
//  Employee.swift
//  EmployeeManagement
//
//  Created by kai_oishi on 2022/08/16.
//

import Foundation

struct EmployeeInfo {
    var id : Int64
    var employeeId :String
    var familyName: String
    var firstName: String
    var sectionId: Int
    var mail: String
    var genderId: Int
    
    init (empId: String, familyName: String, firstName : String, sectionId: Int, mail: String, gender:Int) {
        self.id = Int64(empId.replacingOccurrences(of: "YZ", with: ""))!
        self.employeeId = empId
        self.familyName = familyName
        self.firstName = firstName
        self.sectionId = sectionId
        self.mail = mail
        self.genderId = gender
    }
    
    init (employee: Employee) {
        self.id = employee.id
        self.employeeId = employee.employee_id!
        self.familyName = employee.family_name!
        self.firstName = employee.first_name!
        self.sectionId = Int(employee.section_id)
        self.mail = employee.mail!
        self.genderId = Int(employee.gender_id)
    }

    func meansSectionName() -> String {
        switch self.sectionId {
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
    
    func meansGender() -> String {
        switch self.genderId {
        case 1:
            return "男性"
        case 2:
            return "女性"
        default:
            return "性別"
        }
    }
    
}
