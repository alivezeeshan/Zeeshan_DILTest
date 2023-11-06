

import UIKit


class ArtView: UIView {
    private var paths = [PathWithColor]() // Store paths and their colors
    private var currentPath: UIBezierPath?
    public var strokeColor: UIColor = #colorLiteral(red: 1, green: 0.2993683021, blue: 0.2822492289, alpha: 1) // Default color
    private var strokeWidth: CGFloat = 2.0

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        
        // Get the current graphics context
        if let context = UIGraphicsGetCurrentContext() {
            context.setLineCap(.round)
            context.setLineJoin(.round)
            context.setLineWidth(strokeWidth)
            
            for pathWithColor in paths {
                context.setStrokeColor(pathWithColor.color.cgColor)
                context.addPath(pathWithColor.path.cgPath)
                context.strokePath()
            }
            
            if let currentPath = currentPath {
                context.setStrokeColor(strokeColor.cgColor)
                context.addPath(currentPath.cgPath)
                context.strokePath()
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            currentPath = UIBezierPath()
            currentPath?.lineWidth = strokeWidth
            currentPath?.lineCapStyle = .round
            currentPath?.lineJoinStyle = .round
            currentPath?.move(to: touch.location(in: self))
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            currentPath?.addLine(to: touch.location(in: self))
           // setNeedsDisplay()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let path = currentPath {
                   let pathWithColor = PathWithColor(path: path, color: strokeColor)
                   paths.append(pathWithColor)
                   currentPath = nil
                   
                   // Print the path description
                   print("Path: \(pathWithColor.path)")
                   
                   let delayDuration = strokeColor.getDelayDuration()

                   if delayDuration > 0 {
                       DispatchQueue.main.asyncAfter(deadline: .now() + delayDuration) { [self] in
                           setNeedsDisplay()
                       }
                   }
               }
    }
    // Clear the canvas
    func clear() {
        paths.removeAll()
        setNeedsDisplay()
    }
    
    // Undo the last drawing action
    func undo() {
        if paths.count > 0 {
            paths.removeLast()
            setNeedsDisplay()
        }
    }

    // Set the stroke color for new paths
    func setStrokeColor(_ color: UIColor) {
        strokeColor = color
    }
}

struct PathWithColor {
    let path: UIBezierPath
    let color: UIColor
}

extension UIColor {
    func getDelayDuration() -> TimeInterval {
        var delayDuration: TimeInterval = 0

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let colorString = "R: \(red), G: \(green), B: \(blue), A: \(alpha)"

        switch colorString {
        case "R: 1.0, G: 0.1491314172744751, B: 0.0, A: 1.0":
            delayDuration = 2.0
        case "R: 0.34117648005485535, G: 0.6235294342041016, B: 0.16862745583057404, A: 1.0":
            delayDuration = 5.0
        case "R: 0.1764705926179886, G: 0.49803921580314636, B: 0.7568627595901489, A: 1.0":
            delayDuration = 3.0
        default:
            delayDuration = 2.0
            break
        }

        return delayDuration
    }
}
