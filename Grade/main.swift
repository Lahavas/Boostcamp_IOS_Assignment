//
//  main.swift
//  Grade
//
//  Created by Yeon on 2017. 6. 6..
//  Copyright © 2017년 Yeon. All rights reserved.
//

import Foundation

func roundToNum(num: Double) -> Double {
    let numberOfPlaces = 2.0
    let multiplier = pow(10.0, numberOfPlaces)
    let rounded = round(Double(num) * multiplier) / multiplier
    return rounded
}

func getGrade(score: Double) -> Character {
    switch score {
    case 90...100 :
        return "A"
    case 80..<90 :
        return "B"
    case 70..<80 :
        return "C"
    case 60..<70 :
        return "D"
    default:
        return "F"
    }
}

var credit: [String: Character] = [:]
var completion: [String] = []

var wholeSum: Int = 0
var wholeSubjectNum: Int = 0

let readHandler = FileHandle(forReadingAtPath: "/Users/yeon/students.json")

if let jsonData = readHandler?.readDataToEndOfFile() {
    do {
        let result = try JSONSerialization.jsonObject(with: jsonData, options: [])
        
        if let students = result as? [Any]
        {
            for item in students
            {
                if let student = item as? [String : Any]
                {
                    var scoreAvg: Double = 0.0
                    
                    if let score = student["grade"] as? [String: Int] {
                        var scoreSum: Int = 0
                        var subjectNum: Int = 0
                        
                        if let ds = score["data_structure"] {
                            scoreSum = scoreSum + ds
                            subjectNum = subjectNum + 1
                        }
                        if let algo = score["algorithm"] {
                            scoreSum = scoreSum + algo
                            subjectNum = subjectNum + 1
                        }
                        if let net = score["networking"] {
                            scoreSum = scoreSum + net
                            subjectNum = subjectNum + 1
                        }
                        if let db = score["database"] {
                            scoreSum = scoreSum + db
                            subjectNum = subjectNum + 1
                        }
                        if let os = score["operating_system"] {
                            scoreSum = scoreSum + os
                            subjectNum = subjectNum + 1
                        }
                        
                        scoreAvg = Double(scoreSum) / Double(subjectNum)
                        wholeSum = wholeSum + scoreSum
                        wholeSubjectNum = wholeSubjectNum + subjectNum
                    }
                    
                    if let name = student["name"] as? String {
                        credit[name] = getGrade(score: scoreAvg)
                        
                        if (scoreAvg >= 70.0) {
                            completion.append(name)
                        }
                    }
                }
            }
        }
    } catch {
        print("error")
    }
} else {
    print("jsonData not found")
}

let wholeAvg = roundToNum(num: Double(wholeSum) / Double(wholeSubjectNum))
let sortedCredit = credit.sorted(by: {$0.key < $1.key})
let sortedCompletion = completion.sorted(by: {$0 < $1})

var resultTitle: String = "성적 결과표\n\n"
var resultAvg: String = "전체 평균 : \(wholeAvg)\n\n"
var resultCredit: String = "개인별 학점\n"
for credit in sortedCredit {
    var tmpString: String = "\(credit.key)  : \(credit.value)"
    resultCredit = resultCredit + tmpString + "\n"
}
var resultCompletion: String = "\n수료생\n"
for completion in sortedCompletion {
    var tmpString: String = "\(completion) "
    resultCompletion = resultCompletion + tmpString
}

let result:String = resultTitle + resultAvg + resultCredit + resultCompletion
if let resultData: Data = result.data(using: String.Encoding.utf8) {
    let fm = FileManager.default
    print(fm.createFile(atPath: "/Users/yeon/result.txt", contents: resultData))
}
