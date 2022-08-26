//
//  EmployeeInformationViewController.swift
//  EmployeeManagement
//
//  Created by kai_oishi on 2022/08/26.
//

import UIKit

class EmployeeInformationViewController : UIViewController {
    
    @IBOutlet weak var empIdLabel: UILabel!
    @IBOutlet weak var empNameLabel: UILabel!
    @IBOutlet weak var empSectionLabel: UILabel!
    @IBOutlet weak var empMailLabel: UILabel!
    @IBOutlet weak var empGenderLabel: UILabel!
    
    var selectedEmployee :Employee!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        empIdLabel.text = selectedEmployee.employee_id!
        empNameLabel.text = selectedEmployee.family_name! + " " + selectedEmployee.first_name!
        empSectionLabel.text = selectedEmployee.sectionName()
        empMailLabel.text = selectedEmployee.mail
        empGenderLabel.text = selectedEmployee.gender()
    
    }
    
    @IBAction func didTappEditButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "EditEmployeeViewController", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "EditEmployeeViewController") as! EditEmployeeViewController
        nextVC.storedEmployee = selectedEmployee
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
