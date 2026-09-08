@_exported public import Magnitude
@_exported public import Rotation

/// An oriented elliptical boundary parameterization in a supplied coordinate plane.
/// Semi-axis lengths are finite, nonnegative and ordered major >= minor.
public struct Ellipse<Point, Length: Magnitude::Scalar, Angular: BinaryFloatingPoint> {
    public var center: Point
    public let semiMajor: Magnitude<Length>
    public let semiMinor: Magnitude<Length>
    public var orientation: Rotation<2, Angular>

    public enum Error: Swift.Error, Equatable, Sendable { case unorderedAxes }

    public init(center: Point, semiMajor: Magnitude<Length>, semiMinor: Magnitude<Length>,
                orientation: Rotation<2, Angular>) throws(Error) {
        guard semiMajor.value >= semiMinor.value else { throw .unorderedAxes }
        self.center = center
        self.semiMajor = semiMajor
        self.semiMinor = semiMinor
        self.orientation = orientation
    }

    /// Equal axes are a circular boundary specialization, without a separate owner.
    public static func circle(center: Point, radius: Magnitude<Length>,
                              orientation: Rotation<2, Angular> = .identity) -> Self {
        Self(validatedCenter: center, radius: radius, orientation: orientation)
    }

    /// A directed interval of this elliptical parameterization.
    public struct Arc {
        public var ellipse: Ellipse
        public var interval: Angle.Sweep<Angular>
        public init(ellipse: Ellipse, interval: Angle.Sweep<Angular>) {
            self.ellipse = ellipse
            self.interval = interval
        }
        public func reversed() throws(Angle.Sweep<Angular>.Error) -> Self {
            Self(ellipse: ellipse, interval: try interval.reversed())
        }
    }
}

extension Ellipse: Equatable where Point: Equatable {}
extension Ellipse: Hashable where Point: Hashable, Length: Hashable, Angular: Hashable {}
extension Ellipse: Sendable where Point: Sendable, Length: Sendable, Angular: Sendable {}
extension Ellipse.Arc: Equatable where Point: Equatable {}
extension Ellipse.Arc: Hashable where Point: Hashable, Length: Hashable, Angular: Hashable {}
extension Ellipse.Arc: Sendable where Point: Sendable, Length: Sendable, Angular: Sendable {}

#if !hasFeature(Embedded)
extension Ellipse {
    private enum CodingKeys: String, CodingKey { case center, semiMajor, semiMinor, orientation }
}
extension Ellipse: Encodable where Point: Encodable, Length: Encodable, Angular: Encodable {}
extension Ellipse: Decodable where Point: Decodable, Length: Decodable, Angular: Decodable {
    public init(from decoder: any Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        let center = try c.decode(Point.self, forKey: .center)
        let major = try c.decode(Magnitude<Length>.self, forKey: .semiMajor)
        let minor = try c.decode(Magnitude<Length>.self, forKey: .semiMinor)
        let orientation = try c.decode(Rotation<2, Angular>.self, forKey: .orientation)
        do { try self.init(center: center, semiMajor: major, semiMinor: minor, orientation: orientation) }
        catch {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath,
                debugDescription: "Ellipse semi-major length must be at least its semi-minor length"))
        }
    }
}
extension Ellipse.Arc: Encodable where Point: Encodable, Length: Encodable, Angular: Encodable {}
extension Ellipse.Arc: Decodable where Point: Decodable, Length: Decodable, Angular: Decodable {}
#endif

extension Ellipse {
    private init(validatedCenter: Point, radius: Magnitude<Length>, orientation: Rotation<2, Angular>) {
        self.center = validatedCenter
        self.semiMajor = radius
        self.semiMinor = radius
        self.orientation = orientation
    }
}
