//
//  String+Emoji.swift
//  emoji-swift
//
//  Created by Safx Developer on 2015/04/07.
//  Copyright (c) 2015 Safx Developers. All rights reserved.
//

import Foundation

extension UnicodeScalar {
    
    var isEmoji: Bool {
        
        switch value {
        case 0x1F600...0x1F64F, // Emoticons
        0x1F300...0x1F5FF, // Misc Symbols and Pictographs
        0x1F680...0x1F6FF, // Transport and Map
        0x1F1E6...0x1F1FF, // Regional country flags
        0x2600...0x26FF,   // Misc symbols
        0x2700...0x27BF,   // Dingbats
        0xFE00...0xFE0F,   // Variation Selectors
        0x1F900...0x1F9FF,  // Supplemental Symbols and Pictographs
        65024...65039, // Variation selector
        8400...8447: // Combining Diacritical Marks for Symbols
            return true
            
        default: return false
        }
    }
    
    var isZeroWidthJoiner: Bool {
        
        return value == 8205
    }
}


extension String {

    public static var emojis = emoji {
        didSet {
            emojiUnescapeRegExp = createEmojiUnescapeRegExp()
            emojiEscapeRegExp = createEmojiEscapeRegExp()
        }
    }

    fileprivate static var emojiUnescapeRegExp = createEmojiUnescapeRegExp()
    fileprivate static var emojiEscapeRegExp = createEmojiEscapeRegExp()

    fileprivate static func createEmojiUnescapeRegExp() -> NSRegularExpression {
        return try! NSRegularExpression(pattern: emojis.map { ":\($0.shortname):" } .joined(separator: "|"), options: [])
    }

    fileprivate static func createEmojiEscapeRegExp() -> NSRegularExpression {
        let v = emojis.flatMap { $0.codepoints }.sorted().reversed()
        return try! NSRegularExpression(pattern: v.joined(separator: "|"), options: [])
    }
    
    public var emojiUnescapedString: String {
        var s = self as NSString
        let ms = String.emojiUnescapeRegExp.matches(in: self, options: [], range: NSMakeRange(0, s.length))
        ms.reversed().forEach { m in
            let r = m.range
            let p = s.substring(with: r)
            let px = p[p.index(after: p.startIndex) ..< p.index(before: p.endIndex)]
            let index = String.emojis.firstIndex { $0.shortname == px } // TODO: create dictionary
            if let i = index {
                let e = String.emojis[i]
                s = s.replacingCharacters(in: r, with: e.codepoints.first!) as NSString
            }
        }
        return s as String
    }

    public var emojiEscapedString: String {
        var s = self as NSString
        let ms = String.emojiEscapeRegExp.matches(in: self, options: [], range: NSMakeRange(0, s.length))
        ms.reversed().forEach { m in
            let r = m.range
            let p = s.substring(with: r)
            let index = String.emojis.firstIndex { $0.codepoints.firstIndex { $0 == p } != nil } // TODO: create dictionary
            if let i = index {
                let e = String.emojis[i]
                s = s.replacingCharacters(in: r, with: ":\(e.shortname):") as NSString
            }
        }
        return s as String
    }

    
    
    // Emoji Managment
    fileprivate var emojiScalars: [UnicodeScalar] {
        
        var chars: [UnicodeScalar] = []
        var previous: UnicodeScalar?
        for cur in unicodeScalars {
            
            if let previous = previous, previous.isZeroWidthJoiner && cur.isEmoji {
                chars.append(previous)
                chars.append(cur)
                
            } else if cur.isEmoji {
                chars.append(cur)
            }
            
            previous = cur
        }
        
        return chars
    }
    
    var emojis: [String] {
        
        var scalars: [[UnicodeScalar]] = []
        var currentScalarSet: [UnicodeScalar] = []
        var previousScalar: UnicodeScalar?
        
        for scalar in emojiScalars {
            
            if let prev = previousScalar, !prev.isZeroWidthJoiner && !scalar.isZeroWidthJoiner {
                
                scalars.append(currentScalarSet)
                currentScalarSet = []
            }
            currentScalarSet.append(scalar)
            
            previousScalar = scalar
        }
        
        scalars.append(currentScalarSet)
        
        return scalars.map { $0.map{ String($0) } .reduce("", +) }
    }
    
    var containsEmoji: Bool {

        return unicodeScalars.contains { $0.isEmoji }
    }
    
    func encodeString() -> String {
        
        return self.emojiEscapedString
        
//        let textData: Data? = self.data(using: .nonLossyASCII, allowLossyConversion: true)
//        var encodedStr = self
//        if let aData = textData, let val = String(data: aData, encoding: .utf8) {
//            encodedStr = val
//        }
//        return encodedStr
    }
    func decodeString() -> String {
        
        return self.emojiUnescapedString
        
//        let str = self.replacingOccurrences(of: "\\n", with: "\n")
//        let dataRetrive: Data? = str.data(using: .utf8, allowLossyConversion: true)
//        var decodeStr = self
//        if let aRetrive = dataRetrive, let val = String(data: aRetrive, encoding: .nonLossyASCII) {
//            decodeStr = val
//        }
//        if decodeStr.count == 0 {
//            return str
//        }
//        return decodeStr
    }
}
