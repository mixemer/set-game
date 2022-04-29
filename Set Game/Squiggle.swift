//
//  Squiggle.swift
//  Set Game
//
//  Created by mixemer on 3/23/22.
//

import SwiftUI

struct Squiggle: Shape {
    func path(in rect: CGRect) -> Path {
        let start = CGPoint(x: rect.midX - 20, y: rect.minX)
        let end1 = CGPoint(x: rect.midX + 10, y: rect.maxY * 0.75)
        let end2 = CGPoint(x: rect.midX - 20, y: rect.minY + 40)

        var p = Path()
        
        p.move(to: start)
        p.addQuadCurve(to: end1, control: CGPoint(x: rect.maxX, y: rect.minY))
        p.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.maxY), control: CGPoint(x: rect.maxX - 10, y: rect.maxY * 0.9))
        p.addQuadCurve(to: end2, control: CGPoint(x: rect.minX, y: rect.maxY))
        p.addQuadCurve(to: start, control: CGPoint(x: 0, y: 20))
    
        return p
    }
}
