public struct World {
    public let map: Tilemap
    public var player: Player!
    
    public init(map: Tilemap) {
        self.map = map
        
        for y in 0 ..< map.height {
            for x in 0 ..< map.width {
                let position = Vector(x: Double(x) + 0.5, y: Double(y) + 0.5)
                let thing = map.things[y * map.width + x]
                switch thing {
                case .nothing:
                    break
                case .player:
                    self.player = Player(position: position)
                }
            }
        }
    }
}

public extension World {
    mutating func update(timeStep: Double, input: Input) {
        player.direction = player.direction.rotated(by: input.rotation)
        player.velocity = player.direction * input.speed * player.speed
        player.position += player.velocity * timeStep
        while let intersection = player.intersection(with: map) {
            player.position -= intersection
        }
        // make it unsigned
        // [-1, -1] becomes [size.x - 1, size.y - 1]
//        player.position += size
        
//        player.position.x.formTruncatingRemainder(dividingBy: size.x)
//        player.position.y.formTruncatingRemainder(dividingBy: size.y)
    }
}

public extension World {
    var size: Vector {
        map.size
    }
}
