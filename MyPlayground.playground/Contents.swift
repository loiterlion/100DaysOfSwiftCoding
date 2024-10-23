import UIKit
import Foundation

var greeting = "Hello, playground"

var dic = [String: [String]]()

let arr = dic["abc"]
print(arr)


let nums = [1, 3, 5]
let flattenedNumbs = nums.flatMap { $0 * 2 }
print(flattenedNumbs)

let arrInArr = [1,nil, 2, 3,nil, 4]

print(arrInArr.compactMap { $0 })


let nestedArray: [[Int?]] = [[1, nil, 2], [nil, 3, 4], [5, nil]]

let processed = nestedArray.compactMap{ ($0 ).compactMap{$0} }
print(processed)

let processed1 = nestedArray.reduce([], {$0 + $1}).compactMap{ $0 }
print(processed1)


let processed2 = nestedArray.flatMap { $0 }

let seq = [[1, 2], [3, 4]]
let rlt = Array(seq.joined())
print(rlt)

let number: String = "5"
let result = number.map { Int($0) }
