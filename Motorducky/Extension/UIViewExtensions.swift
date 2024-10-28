//
//  UIViewExtensions.swift

#if os(iOS) || os(tvOS)
import UIKit
import MapKit
// MARK: - enums
extension UITableView {
    func updateHeaderViewHeight() {
        if let header = self.tableHeaderView {
            let newSize = header.systemLayoutSizeFitting(CGSize(width: self.bounds.width, height: 0))
            header.frame.size.height = newSize.height
        }
    }

//    func setEmptyMessage(_ message: String, textColor: UIColor = UM.setColor(.DarkBlue)) {
//        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
//        messageLabel.text = message
//        messageLabel.textColor = textColor
//        messageLabel.numberOfLines = 0
//        messageLabel.textAlignment = .center
//        messageLabel.font = UIFont(name: "Ubuntu-Medium", size: 15)
//        messageLabel.sizeToFit()
//
//        self.backgroundView = messageLabel
//    }
    
    func restore() {
        self.backgroundView = nil
    }
    
    func indexPathOfCell(after indexPath: IndexPath) -> IndexPath? {
        var row = indexPath.row + 1
        for section in indexPath.section..<numberOfSections {
            if row < numberOfRows(inSection: section) {
                return IndexPath(row: row, section: section)
            }
            row = 0
        }
        return nil
    }
    
    func indexPathOfCell(before indexPath: IndexPath) -> IndexPath? {
        var row = indexPath.row - 1
        for section in (0...indexPath.section).reversed() {
            if row >= 0 {
                return IndexPath(row: row, section: section)
            }
            if section > 0 {
                row = numberOfRows(inSection: section - 1) - 1
            }
        }
        return nil
    }
}

public enum ShakeDirection {
	case horizontal
	case vertical
}

public enum AngleUnit {
	case degrees
	case radians
}

public enum ShakeAnimationType {
	case linear
	case easeIn
	case easeOut
	case easeInOut
}

public enum RoundCornersAt{
    case topRight
    case topLeft
    case bottomRight
    case bottomLeft
}

let backgroundView = UIView(frame: UIScreen.main.bounds)

// MARK: - Properties
public extension UIView {
    
    @IBInspectable
    /// Should the corner be as circle
    var circleCorner: Bool {
        get {
            return min(bounds.size.height, bounds.size.width) / 2 == cornerRadius
        }
        set {
            cornerRadius = newValue ? min(bounds.size.height, bounds.size.width) / 2 : cornerRadius
        }
    }
    
	@IBInspectable
    var cornerRadius: CGFloat {
		get {
			return layer.cornerRadius
		}
		set {
			layer.masksToBounds = true
			layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
		}
	}
    
    var firstResponder: UIView? {
		guard !isFirstResponder else {
			return self
		}
		for subView in subviews where subView.isFirstResponder {
			return subView
		}
		return nil
	}
	
    var height: CGFloat {
		get {
			return frame.size.height
		}
		set {
			frame.size.height = newValue
		}
	}
	
    var isRightToLeft: Bool {
		if #available(iOS 10.0, *, tvOS 10.0, *) {
			return effectiveUserInterfaceLayoutDirection == .rightToLeft
		} else {
			return false
		}
	}
	
    var screenshot: UIImage? {
		UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0)
		defer {
			UIGraphicsEndImageContext()
		}
		guard let context = UIGraphicsGetCurrentContext() else {
			return nil
		}
		layer.render(in: context)
		return UIGraphicsGetImageFromCurrentImageContext()
	}
	
    @IBInspectable var shadowColor: UIColor? {
		get {
			guard let color = layer.shadowColor else {
				return nil
			}
			return UIColor(cgColor: color)
		}
		set {
			layer.shadowColor = newValue?.cgColor
		}
	}
    @IBInspectable var shadowOffset: CGSize {
		get {
			return layer.shadowOffset
		}
		set {
			layer.shadowOffset = newValue
		}
	}
    @IBInspectable var shadowOpacity: Float {
		get {
			return layer.shadowOpacity
		}
		set {
			layer.shadowOpacity = newValue
		}
	}
    @IBInspectable var shadowRadius: CGFloat {
		get {
			return layer.shadowRadius
		}
		set {
			layer.shadowRadius = newValue
		}
	}
    var size: CGSize {
		get {
			return frame.size
		}
		set {
			width = newValue.width
			height = newValue.height
		}
	}
    var parentViewController: UIViewController? {
		weak var parentResponder: UIResponder? = self
		while parentResponder != nil {
			parentResponder = parentResponder!.next
			if let viewController = parentResponder as? UIViewController {
				return viewController
			}
		}
		return nil
	}
    var width: CGFloat {
		get {
			return frame.size.width
		}
		set {
			frame.size.width = newValue
		}
	}
    var x: CGFloat {
		get {
			return frame.origin.x
		}
		set {
			frame.origin.x = newValue
		}
	}
	
    var y: CGFloat {
		get {
			return frame.origin.y
		}
		set {
			frame.origin.y = newValue
		}
    }
    
    func dropShadowToView(shadowColor: UIColor) {
        //View Shadow Color
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 3 //7
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = true ? UIScreen.main.scale : 1
    }
    
    func dropShadowToBottomView(shadowColor: UIColor) {
        //View Shadow Color
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset = CGSize(width: 0 , height:3)
        self.layer.shadowRadius = 3 //7
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = true ? UIScreen.main.scale : 1
    }
    
    func dropOnlyOneShadowLeft(getSize: CGSize) {
//        self.layer.shadowColor = themeGrayColor.cgColor
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset = getSize
        self.layer.shadowRadius = 3
    }
    
    //MARK:- Set Button Gradient Colors Method
    func applyGradientVertically(colours: [UIColor]) -> Void {
        self.applyGradientV(colours: colours, locations: nil)
    }
    
    func applyGradientV(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        //        gradient.locations = locations
        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyGradientHorizontally(colours: [UIColor]) -> Void {
        self.applyGradientH(colours: colours, locations: nil)
    }
    
    func applyGradientH(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        //        gradient.locations = locations
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.layer.insertSublayer(gradient, at: 0)
    }

    
    
}


// MARK: - Methods
public extension UIView {
	
    func shake(count : Float = 4,for duration : TimeInterval = 0.3,withTranslation translation : Float = -5) {
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.byValue = translation
        layer.add(animation, forKey: "shake")
    }
    
    func addTapGestureToView()
    {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }
    @objc func handleTap(sender: UITapGestureRecognizer)
    {
        self.endEditing(true)
    }
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
		let maskPath = UIBezierPath(roundedRect: bounds,
									byRoundingCorners: corners,
									cornerRadii: CGSize(width: radius, height: radius))
		let shape = CAShapeLayer()
		shape.path = maskPath.cgPath
		layer.mask = shape
	}
    
    
    //multiple corners using CACornerMask
    func roundCorners(maskedCorners:[RoundCornersAt], radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [
            maskedCorners.contains(.topRight) ? .layerMaxXMinYCorner:.init(),
            maskedCorners.contains(.topLeft) ? .layerMinXMinYCorner:.init(),
            maskedCorners.contains(.bottomRight) ? .layerMaxXMaxYCorner:.init(),
            maskedCorners.contains(.bottomLeft) ? .layerMinXMaxYCorner:.init(),
        ]
    }
        
    func addShadow(ofColor color: UIColor = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0), radius: CGFloat = 3, offset: CGSize = .zero, opacity: Float = 0.5) {
		layer.shadowColor = color.cgColor
		layer.shadowOffset = offset
		layer.shadowRadius = radius
		layer.shadowOpacity = opacity
		layer.masksToBounds = true
	}
    func addSubviews(_ subviews: [UIView]) {
		subviews.forEach({self.addSubview($0)})
	}
	
    func fadeIn(duration: TimeInterval = 0.5, completion: ((Bool) -> Void)? = nil) {
		if isHidden {
			isHidden = false
		}
		UIView.animate(withDuration: duration, animations: {
			self.alpha = 1
		}, completion: completion)
	}
    func fadeOut(duration: TimeInterval = 0.5, completion: ((Bool) -> Void)? = nil) {
		if isHidden {
			isHidden = false
		}
		UIView.animate(withDuration: duration, animations: {
			self.alpha = 0
		}, completion: completion)
	}
	
    class  func loadNibAtIndex(named name: String, bundle: Bundle? = nil,index:Int) -> UIView {
        return (UINib(nibName: name, bundle: bundle).instantiate(withOwner: nil, options: nil)[index] as? UIView)!
    }
    class func loadFromNib(named name: String, bundle: Bundle? = nil) -> UIView? {
		return UINib(nibName: name, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? UIView
	}
	
    func removeSubviews() {
		subviews.forEach({$0.removeFromSuperview()})
	}
	
    func removeGestureRecognizers() {
		gestureRecognizers?.forEach(removeGestureRecognizer)
	}

    func rotate(byAngle angle: CGFloat, ofType type: AngleUnit, animated: Bool = false, duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
		let angleWithType = (type == .degrees) ? CGFloat.pi * angle / 180.0 : angle
		let aDuration = animated ? duration : 0
		UIView.animate(withDuration: aDuration, delay: 0, options: .curveLinear, animations: { () -> Void in
			self.transform = self.transform.rotated(by: angleWithType)
		}, completion: completion)
	}

    func rotate(toAngle angle: CGFloat, ofType type: AngleUnit, animated: Bool = false, duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
		let angleWithType = (type == .degrees) ? CGFloat.pi * angle / 180.0 : angle
		let aDuration = animated ? duration : 0
		UIView.animate(withDuration: aDuration, animations: {
			self.transform = self.transform.concatenating(CGAffineTransform(rotationAngle: angleWithType))
		}, completion: completion)
	}
    func zoomIn()
    {
        if self.isHidden
        {self.isHidden = false}
        self.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.alpha = 1
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: {(_ finished: Bool) -> Void in
        })
    }
    func zoomOut()
    {
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }, completion: {(_ finished: Bool) -> Void in
            self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        })
    }
    func scale(by offset: CGPoint, animated: Bool = false, duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
		if animated {
			UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: { () -> Void in
				self.transform = self.transform.scaledBy(x: offset.x, y: offset.y)
			}, completion: completion)
		} else {
			transform = transform.scaledBy(x: offset.x, y: offset.y)
			completion?(true)
		}
	}
   
    
	
	
	
	/// SwifterSwift: Anchor all sides of the view into it's superview.
    @available(iOS 9, *) func fillToSuperview() {
		// https://videos.letsbuildthatapp.com/
		translatesAutoresizingMaskIntoConstraints = false
		if let superview = superview {
			leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
			rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
			topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
			bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
		}
	}
	
    @available(iOS 9, *) @discardableResult func anchor(
		top: NSLayoutYAxisAnchor? = nil,
		left: NSLayoutXAxisAnchor? = nil,
		bottom: NSLayoutYAxisAnchor? = nil,
		right: NSLayoutXAxisAnchor? = nil,
		topConstant: CGFloat = 0,
		leftConstant: CGFloat = 0,
		bottomConstant: CGFloat = 0,
		rightConstant: CGFloat = 0,
		widthConstant: CGFloat = 0,
		heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
		// https://videos.letsbuildthatapp.com/
		translatesAutoresizingMaskIntoConstraints = false
		
		var anchors = [NSLayoutConstraint]()
		
		if let top = top {
			anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
		}
		
		if let left = left {
			anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
		}
		
		if let bottom = bottom {
			anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
		}
		
		if let right = right {
			anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
		}
		
		if widthConstant > 0 {
			anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
		}
		
		if heightConstant > 0 {
			anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
		}
		
		anchors.forEach({$0.isActive = true})
		
		return anchors
	}

    @available(iOS 9, *) func anchorCenterXToSuperview(constant: CGFloat = 0) {
		translatesAutoresizingMaskIntoConstraints = false
		if let anchor = superview?.centerXAnchor {
			centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
		}
	}

    @available(iOS 9, *) func anchorCenterYToSuperview(constant: CGFloat = 0) {
		translatesAutoresizingMaskIntoConstraints = false
		if let anchor = superview?.centerYAnchor {
			centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
		}
	}
	

    @available(iOS 9, *) func anchorCenterSuperview() {
		anchorCenterXToSuperview()
		anchorCenterYToSuperview()
	}
   
    func setViewBottomBorder(borderColor: UIColor)
    {
        self.backgroundColor = UIColor.clear
        let width = 0.5
        
        let borderLine = UIView()
        borderLine.removeFromSuperview()
        borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - width, width: Double(self.frame.width), height: width)
        borderLine.tag = 99999;
        borderLine.backgroundColor = borderColor
        for v in self.subviews
        {
            if v.tag == 99999
            {
                v.removeFromSuperview()
            }
        }
        self.addSubview(borderLine)
    }
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    func addTapGesture(tapNumber : Int, target: Any , action : Selector) {
        
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    func dropShadow(scale: Bool = true)
    {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 0.4
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    
    func rotateWithLimit(duration: Double = 1)
    {
        if layer.animation(forKey: "rotationanimationkey") == nil
        {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = 10
            layer.add(rotationAnimation, forKey: "rotationanimationkey")
        }
    }
    
    func shadowAccordingRadius()
    {
        var shadowLayer: CAShapeLayer!
        if shadowLayer == nil
        {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.frame.size.height/2).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor
            
            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.4
            shadowLayer.shadowRadius = 2
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    func keepCenterAndApplyAnchorPoint(_ point: CGPoint) {
        
        guard layer.anchorPoint != point else { return }
        
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)
        
        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)
        
        var c = layer.position
        c.x -= oldPoint.x
        c.x += newPoint.x
        
        c.y -= oldPoint.y
        c.y += newPoint.y
        
        layer.position = c
        layer.anchorPoint = point
    }
    
  
    
}
#endif

extension UIImageView {
    func addBlurEffect() {
        let darkBlur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
//        blurView.frame = CGRect(x: 0, y: 0, width: UtilityManager.shared.SCREENWIDTH() , height: self.bounds.height) //self.bounds
        self.addSubview(blurView)
    }
}

extension UIView {
    func addBlurEffectVW() {
        let darkBlur = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: darkBlur)
//        blurView.frame = CGRect(x: 0, y: 0, width: UtilityManager.shared.SCREENWIDTH(), height: self.bounds.height) //self.bounds
        self.addSubview(blurView)
    }
    
    func removeBlurEffectVW(blurView: UIView) {
        for subview in blurView.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
    }
}

extension UIScrollView
{
    func setContentViewSize(offset:CGFloat = 0.0) {
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
        var maxHeight : CGFloat = 0
        for view in subviews {
            if view.isHidden {
                continue
            }
            let newHeight = view.frame.origin.y + view.frame.height
            if newHeight > maxHeight {
                maxHeight = newHeight
            }
        }
        // set content size
        contentSize = CGSize(width: contentSize.width, height: maxHeight + offset)
        // show scroll indicators
        showsHorizontalScrollIndicator = true
        showsVerticalScrollIndicator = true
    }
}
extension UIView
{
    func copyView<T: UIView>() -> T {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
    }
    func addHeight(_ height: CGFloat) {
        self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: self.frame.width, height: self.frame.height + height))
    }
}

extension UIView {
    
    // Transform a view's shape into circle
    func asCircle() {
        self.layer.cornerRadius = self.frame.width / 2;
        self.layer.masksToBounds = true
    }
    
    func setTintColor(_ color: UIColor, recursive: Bool) {
        tintColor = color
        if recursive {
            subviews.forEach({$0.setTintColor(color, recursive: true)})
        }
    }
}
extension CGRect {
    var center: CGPoint {
        get {
            return CGPoint(x: midX, y: midY)
        }
    }
}

    
public extension UIColor {
    static func fromHex(hexString: String) -> UIColor {
        let hex = hexString.trimmingCharacters(
            in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return UIColor.clear
        }
        
        return UIColor(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255)
    }
}
extension Sequence
{
    func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        return Dictionary.init(grouping: self, by: key)
    }
}

extension UINavigationController {
    
    func backToViewController(viewController: Swift.AnyClass) {
        
        for element in viewControllers as Array {
            if element.isKind(of: viewController) {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
}

extension UIImagePickerController
{
    func changePickerTopBarColor(_ tintcolorname:UIColor, _ bartintcolorname:UIColor, _ textcolorname:UIColor)
    {
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = bartintcolorname
        self.navigationBar.tintColor = tintcolorname
        self.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : textcolorname
        ]
    }
}



@IBDesignable class TabBarWithCorners: UITabBar {
    @IBInspectable var color: UIColor?
    @IBInspectable var radious: CGFloat = 8.0

    private var shapeLayer: CALayer?
    private var gradientlayer: CAGradientLayer?

    override func draw(_ rect: CGRect) {
        addShape()
    }

    private func addShape() {
        let shapeLayer = CAShapeLayer()

        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.gray.withAlphaComponent(0.1).cgColor
        shapeLayer.fillColor = UIColor(named: "color666060")?.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowOffset = CGSize(width: 0, height: 0);
        shapeLayer.shadowOpacity = 1
        shapeLayer.shadowPath =  UIBezierPath(rect: bounds).cgPath
        

        let gradientlayer = CAGradientLayer()
        gradientlayer.frame = self.bounds
//        gradientlayer.colors = [UIColor(rgb: 0xF39210).cgColor, UIColor(rgb: 0xF6511D).cgColor]
        gradientlayer.locations = [0, 1]
        gradientlayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientlayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientlayer.cornerRadius = radious
        gradientlayer.masksToBounds = true
        gradientlayer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        gradientlayer.mask = shapeLayer
        
        if let oldShapeLayer = self.gradientlayer {
            layer.replaceSublayer(oldShapeLayer, with: gradientlayer)
        } else {
            layer.insertSublayer(gradientlayer, at: 0)
        }
        
        self.gradientlayer = gradientlayer
        
        /*if let oldShapeLayer = self.shapeLayer {
            layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            layer.insertSublayer(shapeLayer, at: 0)
        }*/
        
        //self.shapeLayer = shapeLayer
    }

    private func createPath() -> CGPath {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: radious, height: 0.0))

        return path.cgPath
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        
        self.isTranslucent = true
        var tabFrame            = self.frame
        tabFrame.size.height    = 65 + (UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.bottom ?? CGFloat.zero)
        tabFrame.origin.y       = self.frame.origin.y +   ( self.frame.height - 65 - (UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.bottom ?? CGFloat.zero))
        self.layer.cornerRadius = 20
        self.frame            = tabFrame



        self.items?.forEach({ $0.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: -5.0) })


    }

}
