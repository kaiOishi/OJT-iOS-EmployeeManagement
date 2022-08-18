//
//  EmployeeTableViewCell.swift
//  EmployeeManagement
//
//  Created by kai_oishi on 2022/08/16.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {
    @IBOutlet weak var employeeIdLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    static let cellIdentifier = String(describing: EmployeeTableViewCell.self)
    
    public func setup(employee: Employee) {
        self.employeeIdLabel.text = employee.employee_id!
        self.nameLabel.text = employee.family_name! + " " + employee.first_name!
    }
}
