//
//  Extensions.swift
//  Networker
//
//  Created by Misha Causur on 16.10.2021.
//

import Foundation
import UIKit

typealias Voidness = (() -> Void)
typealias Intness = ((Int, Int) -> Void)

extension UIView{
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 3.9
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func rotateBack() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * -2)
        rotation.duration = 2.5
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimationBack")
    }
    
    func addSubviews(_ subviews: UIView...)  {
        subviews.forEach{addSubview($0)}
    }
}

extension String {
    func applyPatternOnNumbers(pattern: String, replacementCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacementCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
}

protocol ViewController {
    
    associatedtype RootView: UIView
    
}

extension ViewController where Self: UIViewController {
    
    func view() -> RootView {
        return self.view as! RootView
    }
}

class ImageViewForPost: UIImageView {

    override var intrinsicContentSize: CGSize {

        if let image = self.image {
            let width = image.size.width
            let height = image.size.height
            let viewWidth = self.frame.size.width

            let newWidth = viewWidth/width
            let newHeight = height * newWidth

            return CGSize(width: viewWidth, height: newHeight)
        }

        return CGSize(width: -1.0, height: -1.0)
    }
}
