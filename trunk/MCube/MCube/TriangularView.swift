//
//  TriangularView.swift
//  MCube
//
//  Created by Mukesh Jha on 03/09/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class TriangularView: UIView {

    override func drawRect(rect: CGRect) {
        
        // Get Height and Width
        let layerHeight = self.layer.frame.height
        let layerWidth = self.layer.frame.width
        
        // Create Path
        let bezierPath = UIBezierPath()
        
        // Draw Points
        bezierPath.moveToPoint(CGPointMake(75,10))
        bezierPath.addLineToPoint(CGPointMake(160, 150))
        bezierPath.addLineToPoint(CGPointMake(10, 50))
       // bezierPath.addLineToPoint(CGPointMake(0, layerHeight))
        bezierPath.closePath()
        
        // Apply Color
        UIColor.whiteColor().setFill()
        bezierPath.fill()
        
        // Mask to Path
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.CGPath
        self.layer.mask = shapeLayer
        
    }
    
    
    override func drawRect(rect: CGRect, forViewPrintFormatter formatter: UIViewPrintFormatter) {
  
        // Drawing a triangle using UIBezierPath
        let context = UIGraphicsGetCurrentContext()
        
        // Paint the View Blue before drawing the traingle
        CGContextSetFillColorWithColor(context, UIColor.blueColor().CGColor)  // Set fill color
        CGContextFillRect(context, rect) // Fill rectangle using the context data
        
        // Imagine a triangle resting on the bottom of the container with the base as the width of the rectangle, and the apex of the traingle at the top center of the container
        // The co-ordinates of the rectangle will look like
        // Top = (x: half of Container Width, y: 0 - origin)
        // Bottom Left = (x: 0, y: Container Height)
        // Bottom Right = (x: Container Width, y: Container Height)
        
        // Create path for drawing a triangle
        var trianglePath = UIBezierPath()
        // First move to the Top point
        trianglePath.moveToPoint(CGPoint(x: self.bounds.width/2, y: 0.0))
        // Add line to Bottom Right
        trianglePath.addLineToPoint(CGPoint(x: self.bounds.width, y: self.bounds.height))
        // Add line to Bottom Left
        trianglePath.addLineToPoint(CGPoint(x: 0.0, y: self.bounds.height))
        // Complete path by drawing path to the Top
        trianglePath.addLineToPoint(CGPoint(x: self.bounds.width/2, y: 0.0))
        
        // Set the fill color
        CGContextSetFillColorWithColor(context, UIColor.greenColor().CGColor)
        // Fill the triangle path
        trianglePath.fill()    }

}
