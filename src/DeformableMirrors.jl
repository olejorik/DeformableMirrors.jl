module DeformableMirrors

include("types.jl")
include("utils.jl")
include("visualisation.jl")

export PDM30_37,
    MMDM15_37,
    full_aperture,
    working_aperture,
    actuator_pitch,
    num_actuators,
    set_working_aperture!,
    actuators,
    pdmplot,
    pdmplot!


const PDM30_37 = PDM(hexagonal_grid_hexnums(3, 4.3), 30.0, [22.0], 4.3)
const MMDM15_37 = MMDM(
    [
        Polygon([Point2(p[1], p[2]) for p in polygon]) for
        polygon in [[(0.0, 0.0), (1.0, 0.0), (0.5, 0.866)] for _ in 1:37]
    ],
    15.0,
    [10.0],
    70 * 0.0254,
)

end
