//
//  IdOblutes.swift
//  Tradereverse
//
//  Created by Rizwan on 25/07/2024.
//

import Foundation
import UIKit
extension UITextField{
   @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

class CircularView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.size.height/2
    }
}

class CircularImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.height/2
    }
}

class CircularButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.size.height/2
    }
}


@IBDesignable
class IBDesignableView: UIView {
}

extension UIView {
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var ibcornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var maskedCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
    }
    
    @IBInspectable
    var bottomMaskedCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]//BOTTOM LEFT BOTTOM RIGHT
        }
    }
    
    @IBInspectable
    var topMaskedCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]//TOP LEFT TOP RIGHT
        }
    }
    
    @IBInspectable
    var leftMaskedCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]//TOP LEFT  BOTTOM LEFT
        }
    }
    
    @IBInspectable
    var rightMaskedCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]//TOP RIGHT  BOTTOM RIGHT
        }
    }
    func addBezierShadowMethod() {
        layer.masksToBounds = false
        layer.shadowOpacity = 0.3
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 2
        
        //        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        
        //        layer.shouldRasterize = true
        //        layer.rasterizationScale =  UIScreen.main.scale
    }
    
    func addNormalShadowMethod() {
        layer.masksToBounds = false
        layer.shadowOpacity = 0.08
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 4
    }
    
    @IBInspectable var addBezierShadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addBezierShadowMethod()
            }
        }
    }
    
    @IBInspectable var addNormalShadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addNormalShadowMethod()
            }
        }
    }
    
    
    @IBInspectable var semanticFlipped: Bool {
        get {
            return !transform.isIdentity
        }
        set {
            if newValue == true {
                self.semanticFlipView()
            }
        }
    }
    
    func semanticFlipView() {
        if Constants.shared.languageBool {
           self.transform = CGAffineTransform(scaleX: -1, y: 1)
        } else{
           self.transform = .identity
        }
    }
    
    func addColorShadowMethod() {
        layer.masksToBounds = false
        layer.shadowOpacity = 0.4
//        layer.shadowColor = backgroundColor?.cgColor
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 5
    }
    
    func addSmallColorShadowMethod() {
        layer.masksToBounds = false
        layer.shadowOpacity = 0.4
//        layer.shadowColor = backgroundColor?.cgColor
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 2
    }
    
    @IBInspectable var addColorShadow: Bool {
        get {
            return layer.shadowColor == backgroundColor?.cgColor
        }
        set {
            if newValue == true {
                self.addColorShadowMethod()
            }
        }
    }
    
    @IBInspectable var addSmallColorShadow: Bool {
        get {
            return layer.shadowColor == backgroundColor?.cgColor
        }
        set {
            if newValue == true {
                self.addSmallColorShadowMethod()
            }
        }
    }

    func roundedPolygonPath( lineWidth: CGFloat, sides: NSInteger, cornerRadius: CGFloat, rotationOffset: CGFloat = 0) -> UIBezierPath {
        let rect = self.bounds
        let path = UIBezierPath()
        let theta: CGFloat = CGFloat(2.0 * Float.pi) / CGFloat(sides) // How much to turn at every corner
        let width = min(rect.size.width, rect.size.height)        // Width of the square
        let height = max(rect.size.width, rect.size.height)

        let upperCenter = CGPoint(x: rect.origin.x + width / 2.0, y: rect.origin.y + width / 2.0)
        let bottomCenter = CGPoint(x: upperCenter.x, y: height - upperCenter.y)


            // Radius of the circle that encircles the polygon
            // Notice that the radius is adjusted for the corners, that way the largest outer
            // dimension of the resulting shape is always exactly the width - linewidth
        let radius = (width - lineWidth + cornerRadius - (cos(theta) * cornerRadius)) / 2.0

            // Start drawing at a point, which by default is at the right hand edge
            // but can be offset
        var angle = CGFloat(rotationOffset)
        let bottomCorner = CGPoint(x: bottomCenter.x + (radius - cornerRadius) * cos(angle), y: bottomCenter.y + (radius - cornerRadius) * sin(angle))
        path.move(to: CGPoint(x: bottomCorner.x + cornerRadius * cos(angle + theta), y: bottomCorner.y + cornerRadius * sin(angle + theta)))
            //        print("corner:::\(corner)")
            //        print("point:::\(CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta)))")

        for i in 0 ..< sides {
            angle += theta
            if i == 0 || i == 4 || i == 5 {
                    //bottomCenter
                let corner = CGPoint(x: bottomCenter.x + (radius - cornerRadius) * cos(angle), y: bottomCenter.y + (radius - cornerRadius) * sin(angle))
                let tip = CGPoint(x: bottomCenter.x + radius * cos(angle), y: bottomCenter.y + radius * sin(angle))
                let start = CGPoint(x: corner.x + (cornerRadius * cos(angle - theta)), y: corner.y + (cornerRadius * sin(angle - theta)))
                let end = CGPoint(x: corner.x + (cornerRadius * cos(angle + theta)), y: corner.y + (cornerRadius * sin(angle + theta)))

                path.addLine(to: start)
                path.addQuadCurve(to: end, controlPoint: tip)
            }else {
                    //upperCenter
                let corner = CGPoint(x: upperCenter.x + (radius - cornerRadius) * cos(angle), y: upperCenter.y + (radius - cornerRadius) * sin(angle))
                let tip = CGPoint(x: upperCenter.x + radius * cos(angle), y: upperCenter.y + radius * sin(angle))
                let start = CGPoint(x: corner.x + cornerRadius * cos(angle - theta), y: corner.y + cornerRadius * sin(angle - theta))
                let end = CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta))
                path.addLine(to: start)
                path.addQuadCurve(to: end, controlPoint: tip)
            }
        }

        path.close()
        let transform = CGAffineTransform(translationX: 0, y: 0)
        path.apply(transform)
        return path
    }

}

extension UIImageView {
    @IBInspectable var alwaysTemplateRendering: Bool {
        get {
            guard let renderingMode = image?.renderingMode else { return false }
            return renderingMode == .alwaysTemplate
        }
        set {
            if newValue == true {
                image = image?.withRenderingMode(.alwaysTemplate)
            }
        }
    }
}

class Constants {
    static let shared: Constants = Constants()
    
    var languageBool: Bool = false
}

extension UIProgressView {
    func setGradientProgress(colorTop: UIColor, colorBottom: UIColor) {
        // Remove any existing gradient layer to avoid layering multiple gradients
        if let sublayers = self.layer.sublayers {
            for sublayer in sublayers {
                if sublayer is CAGradientLayer {
                    sublayer.removeFromSuperlayer()
                }
            }
        }

        // Create and configure the gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.frame = self.bounds

        // Render the gradient into an image
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // Set the gradient image as the progressTintColor
        self.progressImage = gradientImage
    }
}
