//
//  Validation.swift
//  EmployeeManagement
//
//  Created by kai_oishi on 2022/08/05.
//

import Foundation

class ValidationEmployeeInfo {
    private init(){}
    
    // 必須入力情報
    private static let requiredItems: [String:Bool] = [
        "id" : true,
        "familyName" : true,
        "firstName" : true,
        "section" : true,
        "mail" : true,
        "gender" : true
    ]
    
    // 固定桁数・最大桁数
    private static let idLength = 10
    private static let familyNameMaxLength = 25
    private static let firstNameMaxLength = 25
    private static let sectionLength = 1
    private static let mailMaxLength = 256
    private static let genderLength = 1
    
    // 他社員のデータと重複してもよい情報
    private static let allowedDuplicationItems: [String:Bool] = [
        "id" : false,
        "familyName" : true,
        "firstName" : true,
        "section" : true,
        "mail" : false,
        "gender" : true
    ]
    
    // 指定フォーマット
    private static let idFormat = "YZ[0-9]{8}"
    private static let familyNameFormat: String? = nil
    private static let firstNameFormat: String? = nil
    private static let sectionFormat = "[1-3]"
    private static let mailFormat = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+$"
    private static let genderFormat = "[1-2]"
    
    // エラーメッセージ
    private static let noInputMessage = "{item}を\n入力してください"
    private static let invalidLengthMessage = "{item}は{length}文字で\n入力してください"
    private static let exceedMaxLengthMessage = "{item}は{length}文字以内\nで入力してください"
    private static let duplicateMessage = "入力した{item}は\nすでに登録されています"
    private static let invalidFormatMessage = "{item}を\n正しく入力してください"
    
    // 外部からの呼び出し用メソッド
    public static func executeValidation(_ inputs:[String:String?]) -> String? {
        // 社員IDバリデーション
        if let invalidMessage = validate(input: inputs["id"], required: requiredItems["id"]!, length: idLength, format: idFormat, allowedDuplicate: allowedDuplicationItems["id"]!) {
            return invalidMessage.replacingOccurrences(of: "{item}", with: "社員ID").replacingOccurrences(of: "{length}", with: String(idLength))
        }
        
        // 社員名(姓)バリデーション
        if let invalidMessage = validate(input: inputs["familyName"], required: requiredItems["familyName"]!, maxLength: familyNameMaxLength, format: familyNameFormat, allowedDuplicate: allowedDuplicationItems["familyName"]!) {
            return invalidMessage.replacingOccurrences(of: "{item}", with: "社員名(姓)").replacingOccurrences(of: "{length}", with: String(familyNameMaxLength))
        }
        
        // 社員名(名)バリデーション
        if let invalidMessage = validate(input: inputs["firstName"], required: requiredItems["firstName"]!, maxLength: firstNameMaxLength, format: firstNameFormat, allowedDuplicate: allowedDuplicationItems["firstName"]!) {
            return invalidMessage.replacingOccurrences(of: "{item}", with: "社員名(名)").replacingOccurrences(of: "{length}", with: String(firstNameMaxLength))
        }
        
        // 所属セクションバリデーション
        if let invalidMessage = validate(input: inputs["section"], required: requiredItems["section"]!, length: sectionLength, format: sectionFormat, allowedDuplicate: allowedDuplicationItems["section"]!) {
            return invalidMessage.replacingOccurrences(of: "{item}", with: "所属セクション").replacingOccurrences(of: "{length}", with: String(sectionLength)).replacingOccurrences(of: "入力", with: "選択")
        }
        
        // メールアドレスバリデーション
        if let invalidMessage = validate(input: inputs["mail"], required: requiredItems["mail"]!, maxLength: mailMaxLength, format: mailFormat, allowedDuplicate: allowedDuplicationItems["mail"]!) {
            return invalidMessage.replacingOccurrences(of: "{item}", with: "メールアドレス").replacingOccurrences(of: "{length}", with: String(mailMaxLength))
        }
        
        // 性別バリデーション
        if let invalidMessage = validate(input: inputs["gender"], required: requiredItems["gender"]!, length: genderLength, format: genderFormat, allowedDuplicate: allowedDuplicationItems["gender"]!) {
            return invalidMessage.replacingOccurrences(of: "{item}", with: "性別").replacingOccurrences(of: "{length}", with: String(genderLength)).replacingOccurrences(of: "入力", with: "選択")
        }
        
        return nil
    }
    
    // 固定長桁数情報用
    private static func validate(input:String??, required:Bool, length:Int, format:String?, allowedDuplicate:Bool) -> String? {
        if let input = input as? String {
            
            if !validateLength(input: input, length: length) { return invalidLengthMessage }
            
            if let format = format {
                if !validateFormat(input: input, format: format) { return invalidFormatMessage }
            }
            
            if !allowedDuplicate && isDuplicate(input: input) { return duplicateMessage }
            
        } else if required { return noInputMessage }
        
        return nil
    }
    
    // 可変長桁数情報用
    private static func validate(input:String??, required:Bool, maxLength:Int, format:String?, allowedDuplicate:Bool) -> String? {
        if let input = input as? String {
            
            if !validateExeedMaxLength(input: input, maxLength: maxLength) { return exceedMaxLengthMessage }
            
            if let format = format {
                if !validateFormat(input: input, format: format) { return invalidFormatMessage }
            }
            
            if !allowedDuplicate && isDuplicate(input: input) { return duplicateMessage }

        } else if required { return noInputMessage }
        
        return nil
    }
    
    // 固定長桁数のバリデート
    private static func validateLength(input:String, length:Int) -> Bool {
        if input.utf8.count == length { return true }
        return false
    }
    
    // 可変長桁数のバリデート
    private static func validateExeedMaxLength(input:String, maxLength:Int) -> Bool {
        if input.utf8.count <= maxLength { return true }
        return false
    }
    
    // 重複のバリデート
    private static func isDuplicate(input:String) -> Bool {
        guard let storedEmployees = AccessCoreData.getStoredEmployee() else { return false }

        if input.contains("@") {
            // メールアドレスの重複確認
            for emp in storedEmployees {
                if emp.mail! == input {
                    return true
                }
            }
        } else {
            // 社員IDの重複確認
            for emp in storedEmployees {
                if emp.employee_id! == input {
                    return true
                }
            }
        }
        
        return false
    }
    
    // フォーマットのバリデート
    private static func validateFormat(input:String, format:String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: format) else { return false }
        let matches = regex.matches(in: input, range: NSRange(location: 0, length: input.utf8.count))
        return matches.count > 0
    }
}
