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
    pdmplot!,
    mmdmplot,
    mmdmplot!


const PDM30_37 = PDM(hexagonal_grid_hexnums(3, 4.3), 30.0, [22.0], 4.3)

# Convert mils to mm for pitch and gap
const mil_to_mm = 0.0254

# Create honeycomb of hexagons with 3 layers (37 actuators), 70mil pitch, 8mil gaps
const MMDM15_37 = MMDM(
    honeycomb_hexagons(3, mil_to_mm * 70, mil_to_mm * 8),
    15.0,
    [10.0]
)

end
