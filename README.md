# swift-ellipse

Use this package when you need an oriented ellipse, or an arc of one, as a plain value over any point type: start from `Ellipse<Point, Length, Angular>`, take `Ellipse.circle` for the equal-axis case, and `Ellipse.Arc` for a swept portion. For a round shape with no orientation use Ball from swift-ball, and for an arc of a circle use Arc from swift-arc.

## Laws

- The semi-major length is never less than the semi-minor length. Equal axes (a circle) and zero axes (a degenerate point) are valid. The ordering is checked on construction and again on decoding, for an `Ellipse` and for the `Ellipse` inside a decoded `Ellipse.Arc`; an unordered pair decodes as a corrupted-data failure.
- `Ellipse.circle` cannot fail: both axes take the radius, and the given orientation is kept, `.identity` by default.
- Equality and hashing compare parameters, not point sets: two circles with the same center and radius but different orientations are unequal.
- `Ellipse.Arc.reversed()` keeps the ellipse and reverses the interval as `Angle.Sweep` does, so the reversed arc starts where the original ended (start plus amount). It fails only when that sweep reversal fails.
