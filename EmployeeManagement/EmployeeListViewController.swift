//
//  EmployeeListViewController.swift
//  EmployeeManagement
//
//  Created by kai_oishi on 2022/08/02.
//

import UIKit

class EmployeeListViewController: UIViewController, UITabBarDelegate {

    @IBOutlet weak var tabBar: UITabBar!
    
    private let employeeList = UITabBarItem(title: "社員一覧", image: nil, tag: 1)
    private let addNewEmployee = UITabBarItem(title: "社員登録", image: nil, tag: 2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "社員一覧"
        tabBar.items = [employeeList, addNewEmployee]
        tabBar.delegate = self
        tabBar.selectedItem = employeeList
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 16)!], for: .normal)
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

