//
//  UIView+Nib.swift
//  Momento
//
//  Created by Александр on 04.11.2021.
//

import Foundation
import UIKit

class NibView: UIView {
    var view: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Setup view from .xib file
        xibSetup()
    }
    
    func setupView() {}
    func setupConstraints() {}
    func localize() {}
    
}

private extension NibView {
    
    func xibSetup() {
        backgroundColor = UIColor.clear
        view = loadNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        self.clipsToBounds = view.clipsToBounds
        self.layer.cornerRadius = view.layer.cornerRadius
        // Adding custom subview on top of our view
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view ?? UIView()]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view ?? UIView()]))
        
        setupView()
        setupConstraints()
        localize()
    }
}

extension UIView {
    /** Loads instance from nib with the same name. */
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView ?? UIView()
    }
}

extension CALayer {
    
    enum BorderSide {
        case top
        case right
        case bottom
        case left
        case notRight
        case notLeft
        case topAndBottom
        case all
        case notBottom
        case notTop
    }
    
    enum Corner {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
    }
    
    func addBorder(side: BorderSide, thickness: CGFloat, color: CGColor, maskedCorners: CACornerMask? = nil) {
        var topWidth = frame.size.width; var bottomWidth = topWidth
        var leftHeight = frame.size.height; var rightHeight = leftHeight
        
        var topXOffset: CGFloat = 0; var bottomXOffset: CGFloat = 0
        var leftYOffset: CGFloat = 0; var rightYOffset: CGFloat = 0
        
        // Draw the corners and set side offsets
        switch maskedCorners {
        case [.layerMinXMinYCorner, .layerMaxXMinYCorner]: // Top only
            addCorner(.topLeft, thickness: thickness, color: color)
            addCorner(.topRight, thickness: thickness, color: color)
            topWidth -= cornerRadius*2
            leftHeight -= cornerRadius; rightHeight -= cornerRadius
            topXOffset = cornerRadius; leftYOffset = cornerRadius; rightYOffset = cornerRadius
            
        case [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]: // Bottom only
            addCorner(.bottomLeft, thickness: thickness, color: color)
            addCorner(.bottomRight, thickness: thickness, color: color)
            bottomWidth -= cornerRadius*2
            leftHeight -= cornerRadius; rightHeight -= cornerRadius
            bottomXOffset = cornerRadius
            
        case [.layerMinXMinYCorner, .layerMinXMaxYCorner]: // Left only
            addCorner(.topLeft, thickness: thickness, color: color)
            addCorner(.bottomLeft, thickness: thickness, color: color)
            topWidth -= cornerRadius; bottomWidth -= cornerRadius
            leftHeight -= cornerRadius*2
            leftYOffset = cornerRadius; topXOffset = cornerRadius; bottomXOffset = cornerRadius;
            
        case [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]: // Right only
            addCorner(.topRight, thickness: thickness, color: color)
            addCorner(.bottomRight, thickness: thickness, color: color)
            topWidth -= cornerRadius; bottomWidth -= cornerRadius
            rightHeight -= cornerRadius*2
            rightYOffset = cornerRadius
            
        case [.layerMaxXMinYCorner, .layerMaxXMaxYCorner,  // All
              .layerMinXMaxYCorner, .layerMinXMinYCorner]:
            addCorner(.topLeft, thickness: thickness, color: color)
            addCorner(.topRight, thickness: thickness, color: color)
            addCorner(.bottomLeft, thickness: thickness, color: color)
            addCorner(.bottomRight, thickness: thickness, color: color)
            topWidth -= cornerRadius*2; bottomWidth -= cornerRadius*2
            topXOffset = cornerRadius; bottomXOffset = cornerRadius
            leftHeight -= cornerRadius*2; rightHeight -= cornerRadius*2
            leftYOffset = cornerRadius; rightYOffset = cornerRadius
            
        default: break
        }
        
        // Draw the sides
        switch side {
        case .top:
            addLine(x: topXOffset, y: 0, width: topWidth, height: thickness, color: color)
            
        case .right:
            addLine(x: frame.size.width - thickness, y: rightYOffset, width: thickness, height: rightHeight, color: color)
            
        case .bottom:
            addLine(x: bottomXOffset, y: frame.size.height - thickness, width: bottomWidth, height: thickness, color: color)
            
        case .left:
            addLine(x: 0, y: leftYOffset, width: thickness, height: leftHeight, color: color)

        // Multiple Sides
        case .notRight:
            addLine(x: topXOffset, y: 0, width: topWidth, height: thickness, color: color)
            addLine(x: 0, y: leftYOffset, width: thickness, height: leftHeight, color: color)
            addLine(x: bottomXOffset, y: frame.size.height - thickness, width: bottomWidth, height: thickness, color: color)

        case .notLeft:
            addLine(x: topXOffset, y: 0, width: topWidth, height: thickness, color: color)
            addLine(x: frame.size.width - thickness, y: rightYOffset, width: thickness, height: rightHeight, color: color)
            addLine(x: bottomXOffset, y: frame.size.height - thickness, width: bottomWidth, height: thickness, color: color)
        case .topAndBottom:
            addLine(x: topXOffset, y: 0, width: topWidth, height: thickness, color: color)
            addLine(x: bottomXOffset, y: frame.size.height - thickness, width: bottomWidth, height: thickness, color: color)
        case .all:
            addLine(x: topXOffset, y: 0, width: topWidth, height: thickness, color: color)
            addLine(x: frame.size.width - thickness, y: rightYOffset, width: thickness, height: rightHeight, color: color)
            addLine(x: bottomXOffset, y: frame.size.height - thickness, width: bottomWidth, height: thickness, color: color)
            addLine(x: 0, y: leftYOffset, width: thickness, height: leftHeight, color: color)
        case .notBottom:
            addLine(x: topXOffset, y: 0, width: topWidth, height: thickness, color: color)
            addLine(x: frame.size.width - thickness, y: rightYOffset, width: thickness, height: rightHeight, color: color)
            addLine(x: 0, y: leftYOffset, width: thickness, height: leftHeight, color: color)
        case .notTop:
            addLine(x: frame.size.width - thickness, y: rightYOffset, width: thickness, height: rightHeight, color: color)
            addLine(x: bottomXOffset, y: frame.size.height - thickness, width: bottomWidth, height: thickness, color: color)
            addLine(x: 0, y: leftYOffset, width: thickness, height: leftHeight, color: color)
        }
        
    }
    
    private func addLine(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: CGColor) {
        let border = CALayer()
        border.frame = CGRect(x: x, y: y, width: width, height: height)
        border.backgroundColor = color
        addSublayer(border)
    }
    
    private func addCorner(_ corner: Corner, thickness: CGFloat, color: CGColor) {
        // Set default to top left
        let width = frame.size.width; let height = frame.size.height
        var x = cornerRadius
        var y = cornerRadius
        var startAngle: CGFloat = .pi; var endAngle: CGFloat = .pi*3/2
        
        switch corner {
        case .bottomLeft:
            y = height - cornerRadius
            startAngle = .pi/2; endAngle = .pi
            
        case .bottomRight:
            x = width - cornerRadius
            y = height - cornerRadius
            startAngle = 0; endAngle = .pi/2
            
        case .topRight:
            x = width - cornerRadius
            startAngle = .pi*3/2; endAngle = 0
            
        default: break
        }
        
        let cornerPath = UIBezierPath(arcCenter: CGPoint(x: x, y: y),
                                      radius: cornerRadius - thickness,
                                      startAngle: startAngle,
                                      endAngle: endAngle,
                                      clockwise: true)

        let cornerShape = CAShapeLayer()
        cornerShape.path = cornerPath.cgPath
        cornerShape.lineWidth = thickness
        cornerShape.strokeColor = color
        cornerShape.fillColor = nil
        addSublayer(cornerShape)
    }
}
