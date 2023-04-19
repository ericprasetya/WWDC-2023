//
//  PKStrokeShape.swift
//  enChanting
//
//  Created by Eric Prasetya Sentosa on 20/04/23.
//

import SwiftUI
import PencilKit

struct PKStrokeShape: Shape {
    var stroke: PKStroke

    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        var previousPoint: PKStrokePoint?
        for point in stroke.path {
            if let previous = previousPoint {
                let midPoint = CGPoint(x: (previous.location.x + point.location.x) / 2,
                                       y: (previous.location.y + point.location.y) / 2)
                path.addQuadCurve(to: midPoint, control: previous.location)
            } else {
                path.move(to: point.location)
            }
            previousPoint = point
        }
        path.closeSubpath()
        
        return path
    }
}
