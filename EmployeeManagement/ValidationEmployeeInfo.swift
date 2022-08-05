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
    private static let requiredItems:[String:Bool] = [
        "id" : true,
        "firstName" : true,
        "lastName" : true,
        "section" : true,
        "mail" : true,
        "gender" : true
    ]
    
    private static let idLength = 10
    private static let firstNameMaxLength = 25
    private static let lastNameMaxLength = 25
    private static let sectionLength = 1
    private static let mailMaxLength = 256
    private static let genderLength = 1
    
    // 他社員のデータと重複してもよい情報
    private static let allowedDuplicationItems:[String:Bool] = [
        "id" : false,
        "firstName" : true,
        "lastName" : true,
        "section" : true,
        "mail" : false,
        "gender" : true
    ]
    
    private static let idFormat = "YZ[0-9]{8}"
    private static let sectionFormat = "[1-3]"
    private static let mailFormat = ".{3}@.{3}"
    private static let genderFormat = "[1-2]"
    
    private static let noInputMessage = "{item}を\n入力してください"
    private static let invalidLengthMessage = "{item}は{length}文字で\n入力してください"
    private static let exceedMaxLengthMessage = "{item}は{length}文字以内\nで入力してください"
    private static let duplicateMessage = "入力した{item}は\nすでに登録されています"
    private static let invalidFormatMessage = "{item}を\n正しく入力してください"
    
    public static func executeValidation(_ inputs:[String:String?]) -> String?{
        // 社員IDバリデーション
        if let invalidMessage = validate(input: inputs["id"], required: requiredItems["id"]!, length: idLength, format: idFormat) {
            return invalidMessage.replacingOccurrences(of: "{item}", with: "社員ID").replacingOccurrences(of: "{length}", with: String(idLength))
        }
        
        // 社員名(姓)バリデーション
        if let invalidMessage = validate(input: inputs["firstName"], required: requiredItems["firstName"]!, maxLength: firstNameMaxLength, format: nil) {
            return invalidMessage.replacingOccurrences(of: "{item}", with: "社員名(姓)").replacingOccurrences(of: "{length}", with: String(firstNameMaxLength))
        }
        
        // 社員名(名)バリデーション
        if let invalidMessage = validate(input: inputs["lastName"], required: requiredItems["lastName"]!, maxLength: lastNameMaxLength, format: nil) {
            return invalidMessage.replacingOccurrences(of: "{item}", with: "社員名(名)").replacingOccurrences(of: "{length}", with: String(lastNameMaxLength))
        }
        
        // 所属セクションバリデーション
        if let invalidMessage = validate(input: inputs["section"], required: requiredItems["section"]!, length: sectionLength, format: sectionFormat) {
            return invalidMessage.replacingOccurrences(of: "{item}", with: "所属セクション").replacingOccurrences(of: "{length}", with: String(sectionLength))
        }
        
        // メールアドレスバリデーション
        if let invalidMessage = validate(input: inputs["mail"], required: requiredItems["section"]!, maxLength: mailMaxLength, format: mailFormat) {
            return invalidMessage.replacingOccurrences(of: "{item}", with: "メールアドレス").replacingOccurrences(of: "{length}", with: String(mailMaxLength))
        }
        
        // 性別バリデーション
        if let invalidMessage = validate(input: inputs["gender"], required: requiredItems["gender"]!, length: genderLength, format: genderFormat) {
            return invalidMessage.replacingOccurrences(of: "{item}", with: "性別").replacingOccurrences(of: "{length}", with: String(genderLength))
        }
        
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
    private static func validateDuplicate(input:String, terget:String) -> Bool {
        return false
    }
    
    // フォーマットのバリデート
    private static func validateFormat(input:String, format:String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: format) else { return false }
        let matches = regex.matches(in: input, range: NSRange(location: 0, length: input.utf8.count))
        return matches.count > 0
    }
    
    // 固定長桁数情報用
    private static func validate(input:String??, required:Bool, length:Int, format:String?) -> String? {
        if let input = input as? String {
            
            if input == "" { return noInputMessage }
            
            if !validateLength(input: input, length: length) { return invalidLengthMessage }
            
            if let format = format {
                if !validateFormat(input: input, format: format) { return invalidFormatMessage }
            }
            
        } else if required { return noInputMessage }
        
        return nil
    }
    
    // 可変長桁数情報用
    private static func validate(input:String??, required:Bool, maxLength:Int, format:String?) -> String? {
        if let input = input as? String {
            
            if input == "" { return noInputMessage }
            
            if !validateExeedMaxLength(input: input, maxLength: maxLength) { return exceedMaxLengthMessage }
            
            if let format = format {
                if !validateFormat(input: input, format: format) { return invalidFormatMessage }
            }
            
        } else if required { return noInputMessage }
        
        return nil
    }
}
