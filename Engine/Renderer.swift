public struct Renderer {
    public private(set) var bitmap: Bitmap
    
    public init(width: Int, height: Int) {
        self.bitmap = Bitmap(width: width, height: height, color: .black)
    }
}

public extension Renderer {
    mutating func draw(_ world: World) {
        // Draw view plane
        let focalLength = 1.0
        let viewWidth = Double(bitmap.width) / Double(bitmap.height)
        let viewPlane = world.player.direction.orthogonal * viewWidth
        let viewCenter = world.player.position + world.player.direction * focalLength
        let viewStart = viewCenter - viewPlane / 2

        // Cast rays
        let columns = bitmap.width
        let step = viewPlane / Double(columns)
        var columnPosition = viewStart
        for x in 0 ..< columns {
            let rayDirection = columnPosition - world.player.position
            let viewPlaneDistance = rayDirection.length
            let ray = Ray(
                origin: world.player.position,
                direction: rayDirection / viewPlaneDistance
            )
            let end = world.map.hitTest(ray)
            columnPosition += step
            
            let wallDistance = (end - ray.origin).length
            let wallHeight = 1.0
            let ditanceRatio = viewPlaneDistance / focalLength
            let perpendicular = wallDistance / ditanceRatio
            let height = wallHeight * focalLength / perpendicular * Double(bitmap.height)
            let wallColor: Color
            if end.x.rounded(.down) == end.x {
                wallColor = .white
            } else {
                wallColor = .gray
            }
            bitmap.drawLine(
                from: Vector(x: Double(x), y: (Double(bitmap.height) - height) / 2),
                to: Vector(x: Double(x), y: (Double(bitmap.height) + height) / 2),
                color: wallColor)
        }
    }
}

private extension Renderer {
    // obsolete
    mutating func draw2D(_ world: World) {
        let scale = Double(bitmap.height) / world.size.y

        // Draw map
        for y in 0 ..< world.map.height {
            for x in 0 ..< world.map.width where world.map[x, y].isWall {
                let rect = Rect(
                    min: Vector(x: Double(x), y: Double(y)) * scale,
                    max: Vector(x: Double(x + 1), y: Double(y + 1)) * scale
                )
                self.bitmap.fill(rect: rect, color: .white)
            }
        }

        // Draw player
        var rect = world.player.rect
        rect.min *= scale
        rect.max *= scale
        self.bitmap.fill(rect: rect, color: .blue)
    }
}
