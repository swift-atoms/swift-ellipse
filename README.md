# Ellipse

A validated boundary parameterization. Constituent values carry their own validity;
center/coordinate frame, plane interpretation and compatible length units are the
calling domain's responsibility. No Vector evaluation, Matrix conversion, metric,
rendering or filled-region containment is installed.

Ellipse contains a generic center, ordered nonnegative Magnitude semi-axes and
Rotation<2, Angular> orientation. Zero axes are accepted as degenerate parameters;
algorithms that divide by axes must separately require positivity. Equal axes use
`.circle(...)`, without a separate Circle package or a Ball/filled-region alias.
Orientation remains significant to representation equality even for circles.
`Ellipse.Arc` contains the ellipse and an Angle.Sweep; it shares angular invariants
with circular arcs without depending on their separate radius representation.
Production URL dependencies are Magnitude and Rotation (which reexports Angle).

Registered in atoms.xcworkspace. GUI-backed native umbrella build-for-testing
and all eight combined Arc/Ellipse tests passed on My Mac, 2026-09-08 21:33.
Final type-boundary and broader affected-owner audit remains open.
