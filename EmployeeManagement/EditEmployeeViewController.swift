//
//  InsertEmployeeViewController.swift
//  EmployeeManagement
//
//  Created by kai_oishi on 2022/08/02.
//

import UIKit

class EditEmployeeViewController : UIViewController{
    @IBOutlet weak var employeeIdField: UITextField!
    @IBOutlet weak var familyNameField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var sectionField: UITextField!
    @IBOutlet weak var mailField: UITextField!
    @IBOutlet weak var manRadioButton: UIButton!
    @IBOutlet weak var womanRadioButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    private var backPreviousBarItem:UIBarButtonItem!
    private let sectionList = ["選択してください", "シス開", "グロカル", "ビジソル"]
    private var sectionPicker:UIPickerView = UIPickerView()
    // true -> 男性, false -> 女性, nil -> 未選択
    private var genderSelection:Bool?
    // 入力値を集約するDictionary
    private var inputs:[String:String?] = [:]
    
    var storedEmployee: Employee?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backPreviousBarItem = UIBarButtonItem(title: "< 戻る", style: .done, target: self, action: #selector(goBackPreviuos(_:)))
        self.navigationItem.leftBarButtonItem = backPreviousBarItem
        employeeIdField.placeholder = "例）YZ12345678"
        familyNameField.placeholder = "性"
        firstNameField.placeholder = "名"
        mailField.placeholder = "例）taro_yaz@yaz.co.jp"
        
        sectionPicker.delegate = self
        sectionPicker.dataSource = self
        sectionField.text = "選択してください"
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        toolbar.setItems([cancelItem, spaceItem, doneItem], animated: true)
        
        sectionField.inputView = self.sectionPicker
        sectionField.inputAccessoryView = toolbar
        
        NotificationCenter.default.addObserver(self,selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
    
        if let storedEmployee = storedEmployee {
            self.employeeIdField.text = storedEmployee.employee_id
            self.familyNameField.text = storedEmployee.family_name
            self.firstNameField.text = storedEmployee.first_name
            self.sectionField.text = storedEmployee.sectionName()
            self.sectionPicker.selectRow(Int(storedEmployee.section_id), inComponent: 0, animated: false)
            self.mailField.text = storedEmployee.mail
            
            if storedEmployee.gender() == "男性" {
                manRadioButton.setTitle("◉", for: .normal)
                womanRadioButton.setTitle("○", for: .normal)
                genderSelection = true
            } else {
                womanRadioButton.setTitle("◉", for: .normal)
                manRadioButton.setTitle("○", for: .normal)
                genderSelection = false
            }
            
            self.employeeIdField.isEnabled = false
            self.registerButton.setTitle("更新", for: .normal)
            done()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 性別選択時に画面の向きを変えると両方選択されてしまうときの対応
    @objc func orientationChanged() {
        if let gs = genderSelection {
            if gs {
                manRadioButton.setTitle("◉", for: .normal)
                womanRadioButton.titleLabel?.text = "○"
            } else {
                womanRadioButton.setTitle("◉", for: .normal)
                manRadioButton.titleLabel?.text = "○"
            }
        }
    }
    
    @objc func goBackPreviuos(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func done() {
        switch (sectionField.text) {
        case "シス開":
            inputs["section"] = "1"
        case "グロカル":
            inputs["section"] = "2"
        case "ビジソル":
            inputs["section"] = "3"
        default:
            inputs["section"] = "0"
        }
        
        self.sectionField.endEditing(true)
    }
    
    @objc func cancel() {
        self.sectionField.text = "選択してください"
        inputs["section"] = "0"
        self.sectionField.endEditing(true)
    }
    
    @IBAction func tappedMan(_ sender: Any) {
        self.genderSelection = true
        manRadioButton.setTitle("◉", for: .normal)
        womanRadioButton.setTitle("○", for: .normal)
    }
    
    @IBAction func tappedWoman(_ sender: Any) {
        self.genderSelection = false
        womanRadioButton.setTitle("◉", for: .normal)
        manRadioButton.setTitle("○", for: .normal)
    }
    
    @IBAction func register(_ sender: Any) {
        inputs["id"] = self.employeeIdField.text == "" ? nil : self.employeeIdField.text
        inputs["familyName"] = self.familyNameField.text == "" ? nil : self.familyNameField.text
        inputs["firstName"] = self.firstNameField.text == "" ? nil : self.firstNameField.text
        inputs["mail"] = self.mailField.text == "" ? nil : self.mailField.text
        
        if let genderSelection = genderSelection {
            inputs["gender"] = genderSelection ? "1" : "2"
        }
        // バリデーションチェックを行い、問題なければnil、問題があればエラーメッセージが返る
        var message:String?
        if storedEmployee == nil {
            message = ValidationEmployeeInfo.executeValidation(inputs, forEdit: false)
        } else {
            message = ValidationEmployeeInfo.executeValidation(inputs, forEdit: true)
        }
        
        if message != nil {
            // 入力値に問題がある場合
            let alert = UIAlertController(title: message!, message: nil, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        } else {
            // 入力値に問題ない場合
            var storeResult :Bool = false
            
            if storedEmployee == nil {
                storeResult = AccessCoreData.storeEmployee(id: inputs["id"]!!, familyName: inputs["familyName"]!!, firstName: inputs["firstName"]!!, section: inputs["section"]!!, mail: inputs["mail"]!!, gender: inputs["gender"]!!)
            } else {
                storeResult = AccessCoreData.updateEmployee(id: inputs["id"]!!, familyName: inputs["familyName"]!!, firstName: inputs["firstName"]!!, section: inputs["section"]!!, mail: inputs["mail"]!!, gender: inputs["gender"]!!)
            }
            
            let purpose = self.storedEmployee == nil ? "登録" : "更新"
            
            if storeResult {
                let alert = UIAlertController(title: "データを\(purpose)しました", message: nil, preferredStyle: .alert)
                let stored = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.dismiss(animated: true, completion: nil)
                    self.navigationController?.popToRootViewController(animated: true)
                }
                
                alert.addAction(stored)
                present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "データ\(purpose)に失敗しました", message: nil, preferredStyle: .alert)
                let stored = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.dismiss(animated: true, completion: nil)
                }
                
                alert.addAction(stored)
                present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
}

extension EditEmployeeViewController:UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sectionList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sectionList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sectionField.text = sectionList[row]
    }
}
