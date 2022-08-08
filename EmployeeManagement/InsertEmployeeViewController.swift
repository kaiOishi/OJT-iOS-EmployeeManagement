//
//  InsertEmployeeViewController.swift
//  EmployeeManagement
//
//  Created by kai_oishi on 2022/08/02.
//

import UIKit

class InsertEmployeeViewController : UIViewController{
    @IBOutlet weak var employeeIdField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backPreviousBarItem = UIBarButtonItem(title: "< 戻る", style: .done, target: self, action: #selector(goBackPreviuos(_:)))
        self.navigationItem.leftBarButtonItem = backPreviousBarItem
        employeeIdField.placeholder = "例）YZ12345678"
        firstNameField.placeholder = "性"
        lastNameField.placeholder = "名"
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
        
        registerButton.backgroundColor = .systemGray
        registerButton.titleLabel?.textColor = .black
        
        manRadioButton.titleLabel?.textColor = .black
        womanRadioButton.titleLabel?.textColor = .black
        
        NotificationCenter.default.addObserver(self,selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
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
                womanRadioButton.titleLabel?.textColor = .black
            } else {
                womanRadioButton.setTitle("◉", for: .normal)
                manRadioButton.titleLabel?.text = "○"
                manRadioButton.titleLabel?.textColor = .black
            }
        }
    }
    
    @objc func goBackPreviuos(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
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
        womanRadioButton.titleLabel?.text = "○"
        womanRadioButton.titleLabel?.textColor = .black
        inputs["gender"] = "1"
    }
    
    @IBAction func tappedWoman(_ sender: Any) {
        self.genderSelection = false
        womanRadioButton.setTitle("◉", for: .normal)
        manRadioButton.titleLabel?.text = "○"
        manRadioButton.titleLabel?.textColor = .black
        inputs["gender"] = "2"
    }
    
    @IBAction func register(_ sender: Any) {
        if self.employeeIdField.text == "" {
            inputs["id"] = nil
        } else {
            inputs["id"] = self.employeeIdField.text
        }
        
        if self.firstNameField.text == "" {
            inputs["firstName"] = nil
        } else {
            inputs["firstName"] = self.firstNameField.text
        }
        
        if self.lastNameField.text == "" {
            inputs["lastName"] = nil
        } else {
            inputs["lastName"] = self.lastNameField.text
        }
        
        if self.mailField.text == "" {
            inputs["mail"] = nil
        } else {
            inputs["mail"] = self.mailField.text
        }
        
        // バリデーションチェックを行い、問題なければnil、問題があればエラーメッセージが返る
        let message = ValidationEmployeeInfo.executeValidation(inputs)
        
        if message != nil {
            let alert = UIAlertController(title: message!, message: nil, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    
}

extension InsertEmployeeViewController:UIPickerViewDelegate, UIPickerViewDataSource {
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
