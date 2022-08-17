//
//  EmployeeListViewController.swift
//  EmployeeManagement
//
//  Created by kai_oishi on 2022/08/02.
//

import UIKit

class EmployeeListViewController: UIViewController, UITabBarDelegate {

    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var employeeTable: UITableView!
    
    var storedEmployee: [EmployeeInfo] = []
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
        
        let nib = UINib(nibName: EmployeeTableViewCell.cellIdentifier, bundle: nil)
        employeeTable.register(nib, forCellReuseIdentifier: EmployeeTableViewCell.cellIdentifier)
        employeeTable.rowHeight = UITableView.automaticDimension
        
        let stored = AccessCoreData.getStoredEmployee()!
        for emp in stored {
            let empInfo = EmployeeInfo(employee: emp)
            storedEmployee.append(empInfo)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        let stored = AccessCoreData.getStoredEmployee()!
        storedEmployee = []
        for emp in stored {
            let empInfo = EmployeeInfo(employee: emp)
            storedEmployee.append(empInfo)
        }
        
        employeeTable.reloadData()
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 2 {
            let storyBoard = UIStoryboard(name: "InsertEmployeeViewController", bundle: nil)
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "InsertEmployeeViewController")
            navigationController?.pushViewController(nextVC, animated: true)
            tabBar.selectedItem = employeeList
        }
    }
}

extension EmployeeListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storedEmployee.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeTableViewCell.cellIdentifier) as! EmployeeTableViewCell
        cell.setup(employee: storedEmployee[indexPath.row])
        
        return cell
    }
    
}


