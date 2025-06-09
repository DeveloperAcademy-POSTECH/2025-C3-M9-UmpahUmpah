import SwiftUI

// 커스텀 삼각형 셰이프
struct CustomTriangleShape: Shape {
    private var width: CGFloat
    private var height: CGFloat
    private var radius: CGFloat
    
    init(width: CGFloat = 40, height: CGFloat = 25, radius: CGFloat = 1) {
        self.width = width
        self.height = height
        self.radius = radius
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + width / 2 - radius, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX + width, y: rect.minY + height))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + height))
        path.closeSubpath()
        return path
    }
}

