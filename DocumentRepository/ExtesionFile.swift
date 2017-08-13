//
//  ExtesionFile.swift
//  webMOBI
//
//  Created by webmobi on 5/18/17.
//  Copyright © 2017 Webmobi. All rights reserved.
//

import UIKit

public class TimeConversion {
    
    func stringfrommilliseconds(ms: Double, format: String) -> String {
        let date = Date(timeIntervalSince1970: (ms / 1000.0))
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from: date)
    }
    
    func localtimestringfrommilliseconds(ms: Double, format: String) -> String {
        let date = Date(timeIntervalSince1970: (ms / 1000.0))
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func stringfromdate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from: date)
    }
    
}

public class randColor {

    func randomInt(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
    func getRandomColor() -> UIColor{
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(randomInt(firstNum: 0.5, secondNum:1.0))
        let green:CGFloat = CGFloat(randomInt(firstNum: 0.5, secondNum:1.0))
        let blue:CGFloat = CGFloat(randomInt(firstNum: 0.5, secondNum:1.0))
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
}

extension UIImageView
{
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}
extension UITextField {
    func setBottomBorder(color : UIColor,width : CGFloat ) {
        let border = CALayer()
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

extension UILabel {
    func setBottomBorder(color : UIColor,width : CGFloat ) {
        let border = CALayer()
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

extension UIView {
    func fadeIn() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: nil)
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
    
    func rotate360Degrees(duration: CFTimeInterval = 1) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount=Float.infinity
        self.layer.add(rotateAnimation, forKey: nil)
    }
    
    func addLoader() {
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.tag = 1000
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
        
        
        let imageName = "loading"
        let image = UIImage(named: imageName)
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: tintedImage!)
        imageView.tintColor = UIColor.white
        imageView.frame = CGRect(x: self.frame.midX-25, y: self.frame.midY-25, width: 50, height: 50)
        imageView.tag = 404
        imageView.rotate360Degrees(duration: 1)
        self.addSubview(imageView)
        
    }
    
    func removeLoader() {
        
        if let loaderview = self.viewWithTag(404){
            loaderview.removeFromSuperview()
        }else{
            print("No Loader Activated")
        }
        if let Blurview = self.viewWithTag(1000){
            Blurview.removeFromSuperview()
        }else{
            print("No Loader Activated")
        }
        
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func createGradientLayer(color1 : UIColor , color2 : UIColor) {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.frame
        
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        
        self.layer.addSublayer(gradientLayer)
    }
    func createGradientLayerwithStartandEndpoint(color1 : UIColor , color2 : UIColor,startPoint : CGPoint,endPoint: CGPoint) {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        gradientLayer.startPoint = startPoint //CGPoint(x:0.0, y:0.5)
        gradientLayer.endPoint = endPoint //CGPoint(x:1.0, y:0.5)
        self.layer.addSublayer(gradientLayer)
    }
}

extension UIImage{
    
    func cropImageToSquare() -> UIImage? {
        var imageHeight = self.size.height
        var imageWidth = self.size.width
        
        if imageHeight > imageWidth {
            imageHeight = imageWidth
        }
        else {
            imageWidth = imageHeight
        }
        
        let size = CGSize(width: imageWidth, height: imageHeight)
        
        let refWidth : CGFloat = CGFloat(self.cgImage!.width)
        let refHeight : CGFloat = CGFloat(self.cgImage!.height)
        
        let x = (refWidth - size.width) / 2
        let y = (refHeight - size.height) / 2
        
        let cropRect = CGRect(x: x, y: y, width: size.height, height: size.width)
        if let imageRef = self.cgImage!.cropping(to: cropRect) {
            return UIImage(cgImage: imageRef, scale: 0, orientation: self.imageOrientation)
        }
        
        return nil
    }
    
        func alpha(_ value:CGFloat)->UIImage
        {
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage!
            
        }
    
}

extension String {
    var html2AttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    mutating func trim() ->String
    {
        return self.trimmingCharacters(in: .whitespaces)
    }
    var first: String {
        return String(characters.prefix(1))
    }
    var last: String {
        return String(characters.suffix(1))
    }
    var uppercaseFirst: String {
        return first.uppercased() + String(characters.dropFirst())
    }
    
    static func className(aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(from: Int) -> String {
        return self.substring(from: self.index(startIndex, offsetBy: from))  //substringFrom(self.startIndex.advancedBy(from))
    }
    
    var length: Int {
        return self.characters.count
    }
    var parseJSONString: [AnyObject] {
        
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        if let jsonData = data {
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [AnyObject] {
                    return jsonResult
                }
            } catch  {
                return []
            }
            
        } else {
            // Lossless conversion of the string was not possible
            return []
        }
        return []
    }
}
