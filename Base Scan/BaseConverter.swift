//
//  BaseConverter.swift
//  Base Scan
//
//  Created by Mettaworldj on 4/26/21.
//

import SwiftUI
import BigNumber
import MobileCoreServices

class BaseConverter: ObservableObject {
    
    func convert(fromBase: String, fromNumber: String, toBase: String) -> String? {
        guard let fromBase = Int(fromBase),
              let toBase = Int(toBase)
        else { return nil }
        
        if (2...36 ~= fromBase) && (2...36 ~= toBase) {
        
            if String(Int.max).count >= fromNumber.count {
                guard let fromValue = Int(fromNumber.trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: .punctuationCharacters).replacingOccurrences(of: ",", with: ""), radix: fromBase) else { return nil }
                return String(fromValue, radix: toBase).uppercased()
            } else {
                guard let num = BInt(fromNumber, radix: fromBase) else { return nil }
                return String(num, radix: toBase).uppercased()
            }
            
        }
        
        return nil
    }
}
