//
//  TriangularView.swift
//  MCube
//
//  Created by Mukesh Jha on 03/09/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class TriangularView: UIView {

    override func draw(_ rect: CGRect) {
        
        // Get Height and Width
        _ = self.layer.frame.height
        _ = self.layer.frame.width
        
        // Create Path
        let bezierPath = UIBezierPath()
        
        // Draw Points
        bezierPath.move(to: CGPoint(x: 75,y: 10))
        bezierPath.addLine(to: CGPoint(x: 160, y: 150))
        bezierPath.addLine(to: CGPoint(x: 10, y: 50))
       // bezierPath.addLineToPoint(CGPointMake(0, layerHeight))
        bezierPath.close()
        
        // Apply Color
        UIColor.white.setFill()
        bezierPath.fill()
        
        // Mask to Path
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        self.layer.mask = shapeLayer
        
    }
    
    
    override func draw(_ rect: CGRect, for formatter: UIViewPrintFormatter) {
  
        // Drawing a triangle using UIBezierPath
        let context = UIGraphicsGetCurrentContext()
        
        // Paint the View Blue before drawing the traingle
        context?.setFillColor(UIColor.blue.cgColor)  // Set fill color
        context?.fill(rect) // Fill rectangle using the context data
        
        // Imagine a triangle resting on the bottom of the container with the base as the width of the rectangle, and the apex of the traingle at the top center of the container
        // The co-ordinates of the rectangle will look like
        // Top = (x: half of Container Width, y: 0 - origin)
        // Bottom Left = (x: 0, y: Container Height)
        // Bottom Right = (x: Container Width, y: Container Height)
        
        // Create path for drawing a triangle
        let trianglePath = UIBezierPath()
        // First move to the Top point
        trianglePath.move(to: CGPoint(x: self.bounds.width/2, y: 0.0))
        // Add line to Bottom Right
        trianglePath.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
        // Add line to Bottom Left
        trianglePath.addLine(to: CGPoint(x: 0.0, y: self.bounds.height))
        // Complete path by drawing path to the Top
        trianglePath.addLine(to: CGPoint(x: self.bounds.width/2, y: 0.0))
        
        // Set the fill color
        context?.setFillColor(UIColor.green.cgColor)
        // Fill the triangle path
        trianglePath.fill()    }

}
