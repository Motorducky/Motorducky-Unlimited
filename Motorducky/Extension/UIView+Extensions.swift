import UIKit
import Foundation

// MARK: - Designable Extension

@IBDesignable
extension UIView {
    
    @IBInspectable
    /// Shadow path of view; also inspectable from Storyboard.
    public var shadowPath: CGPath? {
        get {
            return layer.shadowPath
        }
        set {
            layer.shadowPath = newValue
        }
    }
    
    @IBInspectable
    /// Should shadow rasterize of view; also inspectable from Storyboard.
    /// cache the rendered shadow so that it doesn't need to be redrawn
    public var shadowShouldRasterize: Bool {
        get {
            return layer.shouldRasterize
        }
        set {
            layer.shouldRasterize = newValue
        }
    }
    
    @IBInspectable
    /// Should shadow rasterize of view; also inspectable from Storyboard.
    /// cache the rendered shadow so that it doesn't need to be redrawn
    public var shadowRasterizationScale: CGFloat {
        get {
            return layer.rasterizationScale
        }
        set {
            layer.rasterizationScale = newValue
        }
    }
    
    @IBInspectable
    /// Corner radius of view; also inspectable from Storyboard.
    public var maskToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
}


// MARK: - Properties
internal extension UIView {
    func dlgpicker_setupRoundCorners() {
        self.layer.cornerRadius = min(bounds.size.height, bounds.size.width) / 2
    }
}

extension UIView {
    
    func superview<T>(of type: T.Type) -> T? {
        return superview as? T ?? superview.flatMap { $0.superview(of: T.self) }
    }
    
}


// MARK: - Methods

public extension UIView {
    
    public typealias Configuration = (UIView) -> Swift.Void
    
    public func config(configurate: Configuration?) {
        configurate?(self)
    }
}

extension UIView {
    
    func searchVisualEffectsSubview() -> UIVisualEffectView? {
        if let visualEffectView = self as? UIVisualEffectView {
            return visualEffectView
        } else {
            for subview in subviews {
                if let found = subview.searchVisualEffectsSubview() {
                    return found
                }
            }
        }
        return nil
    }
    
    /// This is the function to get subViews of a view of a particular type
    /// https://stackoverflow.com/a/45297466/5321670
    func subViews<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        for view in self.subviews {
            if let aView = view as? T{
                all.append(aView)
            }
        }
        return all
    }
    
    
    /// This is a function to get subViews of a particular type from view recursively. It would look recursively in all subviews and return back the subviews of the type T
    /// https://stackoverflow.com/a/45297466/5321670
    func allSubViewsOf<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T{
                all.append(aView)
            }
            guard view.subviews.count>0 else { return }
            view.subviews.forEach{ getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
    
    static func instantiateFromNib() -> Self {
        func instanceFromNib<T: UIView>() -> T {
            let identifier = String(describing: T.self)
            return UINib(nibName: identifier, bundle: nil).instantiate(withOwner: nil, options: nil).first as! T
        }
        return instanceFromNib()
    }
}

extension UIView {
    
//    func applyGradient(colors: [UIColor] = [UIColor(rgb: 0xF6D31D), UIColor(rgb: 0xF6511D), UIColor(rgb: 0xF21111)], startPoint:CGPoint = CGPoint(x: 0.1, y: 0.3), endPoint:CGPoint = CGPoint(x: 1.0, y: 0.7), locations: [NSNumber] = [0.0, 0.7, 1.0]) {
//        let gradient: CAGradientLayer = CAGradientLayer()
//        gradient.frame = self.bounds
//        gradient.colors = colors.map { $0.cgColor }
//        gradient.locations = locations
//        gradient.startPoint = startPoint
//        gradient.endPoint = endPoint
//        self.layer.insertSublayer(gradient, at: 0)
//    }
    
    open func removeGradientLayer() {
        if let layers = self.layer.sublayers {
            for aLayer in layers {
                if aLayer is CAGradientLayer {
                    aLayer.removeFromSuperlayer()
                    break
                }
            }
        }
    }
    
    func addInnerShadow(to edges: [UIRectEdge], radius: CGFloat = 3.0, opacity: Float = 0.6, color: CGColor = UIColor.black.cgColor) {
            let fromColor = color
            let toColor = UIColor.clear.cgColor
            let viewFrame = self.frame
            for edge in edges {
                let gradientLayer = CAGradientLayer()
                gradientLayer.colors = [fromColor, toColor]
                gradientLayer.opacity = opacity

                switch edge {
                case .top:
                    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
                    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
                    gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: viewFrame.width, height: radius)
                case .bottom:
                    gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
                    gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
                    gradientLayer.frame = CGRect(x: 0.0, y: viewFrame.height - radius, width: viewFrame.width, height: radius)
                case .left:
                    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                    gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
                    gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: radius, height: viewFrame.height)
                case .right:
                    gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                    gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
                    gradientLayer.frame = CGRect(x: viewFrame.width - radius, y: 0.0, width: radius, height: viewFrame.height)
                default:
                    break
                }
                self.layer.addSublayer(gradientLayer)
            }
        }

        func removeAllShadows() {
            if let sublayers = self.layer.sublayers, !sublayers.isEmpty {
                for sublayer in sublayers {
                    sublayer.removeFromSuperlayer()
                }
            }
        }
}

@IBDesignable
public class AngleView: UIView {
    
    @IBInspectable public var fillColor: UIColor = .red { didSet { setNeedsLayout() } }
    
    var points: [CGPoint] = [
        .zero,
        CGPoint(x: 0.45, y: 0),
        CGPoint(x: 0.55, y: 1),
        CGPoint(x: 0, y: 1)
    ] { didSet { setNeedsLayout() } }
    
    private lazy var shapeLayer: CAShapeLayer = {
        let _shapeLayer = CAShapeLayer()
        self.layer.insertSublayer(_shapeLayer, at: 0)
        return _shapeLayer
    }()
    
    override public func layoutSubviews() {
        shapeLayer.fillColor = fillColor.cgColor
        
        guard points.count > 2 else {
            shapeLayer.path = nil
            return
        }
        
        let path = UIBezierPath()
        
        path.move(to: convert(relativePoint: points[0]))
        for point in points.dropFirst() {
            path.addLine(to: convert(relativePoint: point))
        }
        path.close()
        
        shapeLayer.path = path.cgPath
    }
    
    private func convert(relativePoint point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x * bounds.width + bounds.origin.x, y: point.y * bounds.height + bounds.origin.y)
    }
}
