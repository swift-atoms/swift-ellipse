import Ellipse
import Testing
import Foundation

@Suite struct `Ellipse constituent contracts` {
    @Test func `Major and minor axes must be ordered`() throws {
        #expect(throws: Ellipse<Int, Int, Double>.Error.unorderedAxes) {
            try Ellipse(center: 0, semiMajor: Magnitude(validating: 2),
                        semiMinor: Magnitude(validating: 3), orientation: Rotation<2, Double>.identity)
        }
    }
    @Test func `Zero axes are accepted as degenerate boundary parameters`() throws {
        let ellipse = try Ellipse(center: "origin", semiMajor: Magnitude<Int>.zero,
                                  semiMinor: .zero, orientation: Rotation<2, Double>.identity)
        #expect(ellipse.semiMajor == .zero)
        #expect(ellipse.semiMinor == .zero)
    }
    @Test func `Circle specialization retains orientation parameterization`() throws {
        let orientation = Rotation(try Rotation<2, Double>.Plane(first: .primary, second: .secondary, angle: .pi.half))
        let circle = Ellipse<Int, Int, Double>.circle(center: 0, radius: try Magnitude(validating: 2), orientation: orientation)
        #expect(circle.semiMajor == circle.semiMinor)
        #expect(circle.orientation == orientation)
        #expect(Set([circle, circle]).count == 1)
    }
    @Test func `Elliptical arc reversal reuses the validated interval`() throws {
        let ellipse = Ellipse<Int, Int, Double>.circle(center: 0, radius: .zero)
        let arc = Ellipse.Arc(ellipse: ellipse,
            interval: try Angle.Sweep<Double>(start: Radian(_unchecked: 1), amount: Radian(_unchecked: 2)))
        #expect(try arc.reversed().ellipse == ellipse)
        #expect(try arc.reversed().interval.start.underlying == 3)
    }
    @Test func `Decoding revalidates axis ordering and round trips arcs`() throws {
        let ellipse = Ellipse<Int, Int, Double>.circle(center: 1, radius: try Magnitude(validating: 2))
        let arc = Ellipse.Arc(ellipse: ellipse, interval: try Angle.Sweep<Double>(start: .zero, amount: .pi.two))
        #expect(try JSONDecoder().decode(Ellipse<Int, Int, Double>.Arc.self, from: JSONEncoder().encode(arc)) == arc)
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(Ellipse<Int, Int, Double>.self,
                from: Data(#"{"center":0,"semiMajor":1,"semiMinor":2,"orientation":{"planes":[]}}"#.utf8))
        }
    }
}
