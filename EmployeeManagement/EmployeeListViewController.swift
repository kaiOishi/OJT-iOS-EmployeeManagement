//
//  EmployeeListViewController.swift
//  EmployeeManagement
//
//  Created by kai_oishi on 2022/08/02.
//

import UIKit

class EmployeeListViewController: UIViewController, UITabBarDelegate {

    @IBOutlet weak var tabBar: UITabBar!
    
    private let employeeList = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
    private let addNewEmployee = UITabBarItem(tabBarSystemItem: .downloads, tag: 2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "社員一覧"

        tabBar.items = [employeeList, addNewEmployee]
        tabBar.delegate = self
        tabBar.selectedItem = employeeList
    }

    override func viewDidAppear(_ animated: Bool) {
        tabBar.selectedItem = employeeList
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 2 {
            let storyBoard = UIStoryboard(name: "InsertEmployeeViewController", bundle: nil)
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "InsertEmployeeViewController")
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}

