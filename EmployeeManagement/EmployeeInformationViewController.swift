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
    
    @IBAction func didTapEditButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "EditEmployeeViewController", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "EditEmployeeViewController") as! EditEmployeeViewController
        nextVC.storedEmployee = selectedEmployee
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func didTapDeleteButton(_ sender: Any) {
        var deleteResult = false
        let confirm = UIAlertController(title: "データを削除します\nよろしいですか？", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
             deleteResult = AccessCoreData.deleteEmployee(id: self.selectedEmployee.employee_id!)
            self.dismiss(animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "キャンセル", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        confirm.addAction(ok)
        confirm.addAction(cancel)
        present(confirm, animated: true, completion: nil)
        
        let affirm = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        if deleteResult {
            let deleteSuccess = UIAlertController(title: "データを削除しました", message: nil, preferredStyle: .alert)
            deleteSuccess.addAction(affirm)
            present(deleteSuccess, animated: true, completion: nil)

        } else {
            let deleteFail =  UIAlertController(title: "データを削除しました", message: nil, preferredStyle: .alert)
            deleteFail.addAction(affirm)
            present(deleteFail, animated: true, completion: nil)
        }
        
    }
}
