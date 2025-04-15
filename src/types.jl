using GeometryBasics: Point2, Polygon

export PDM, MMDM

abstract type WavefrontCorrector end

abstract type DeformableMirror <: WavefrontCorrector end

"""
    struct PDM

Represents a Piezoelectric Deformable Mirror (PDM).

# Fields
- `actuator_positions::Vector{Point2}`: List of actuator center positions as 2D points.
- `full_aperture::Float64`: Full aperture of the mirror in millimeters.
- `working_aperture::Vector{Float64}`: Mutable array representing the working aperture in millimeters.
- `actuator_pitch::Float64`: Distance between adjacent actuators in millimeters.

# Example
```julia
pdm = PDM([Point2(0.0, 0.0), Point2(1.0, 1.0)], 30.0, [22.0], 4.3)
```
"""
struct PDM <: DeformableMirror
    actuator_positions::Vector{Point2} # List of actuator center positions as 2D points
    full_aperture::Float64
    working_aperture::Vector{Float64} # Mutable array for working aperture
    actuator_pitch::Float64
end

"""
    struct MMDM

Represents a Micro-Machined Deformable Mirror (MMDM).

# Fields
- `actuator_polygons::Vector{Polygon}`: List of actuator polygons as GeometryBasics.Polygon.
- `full_aperture::Float64`: Full aperture of the mirror in millimeters.
- `working_aperture::Vector{Float64}`: Mutable array representing the working aperture in millimeters.
- `actuator_pitch::Float64`: Distance between adjacent actuators in millimeters.

# Example
```julia
mmdm = MMDM([Polygon([(0.0, 0.0), (1.0, 0.0), (0.5, 0.866)])], 15.0, [10.0], 70 * 0.0254)
```
"""
struct MMDM <: DeformableMirror
    actuator_polygons::Vector{Polygon} # List of actuator polygons as GeometryBasics.Polygon
    full_aperture::Float64
    working_aperture::Vector{Float64} # Mutable array for working aperture
    actuator_pitch::Float64
end

"""
    full_aperture(mirror::DeformableMirror) -> Float64

Returns the full aperture of the given deformable mirror.

# Example
```julia
aperture = full_aperture(PDM30_37)
```
"""
function full_aperture(mirror::DeformableMirror)
    return error("Type $(typeof(mirror)) of the mirror doesn't define the full aperture")
end

function full_aperture(mirror::Union{PDM,MMDM})
    return mirror.full_aperture
end

"""
    working_aperture(mirror::DeformableMirror) -> Float64

Returns the working aperture of the given deformable mirror.

# Example
```julia
aperture = working_aperture(MMDM15_37)
```
"""
function working_aperture(mirror::DeformableMirror)
    return error("Type $(typeof(mirror)) of the mirror doesn't define the working aperture")
end

function working_aperture(mirror::Union{PDM,MMDM})
    return mirror.working_aperture[1] # Return the first element of the array
end

"""
    set_working_aperture!(mirror::DeformableMirror, new_aperture::Float64)

Sets the working aperture of the given deformable mirror.

# Example
```julia
set_working_aperture!(PDM30_37, 20.0)
```
"""
function set_working_aperture!(mirror::DeformableMirror, new_aperture::Float64)
    return error(
        "Type $(typeof(mirror)) of the mirror doesn't support setting the working aperture"
    )
end

function set_working_aperture!(mirror::Union{PDM,MMDM}, new_aperture::Float64)
    return mirror.working_aperture[1] = new_aperture # Update the first element of the array
end

"""
    actuator_pitch(mirror::DeformableMirror) -> Float64

Returns the actuator pitch of the given deformable mirror.

# Example
```julia
pitch = actuator_pitch(MMDM15_37)
```
"""
function actuator_pitch(mirror::DeformableMirror)
    return error("Type $(typeof(mirror)) of the mirror doesn't define the actuator pitch")
end

function actuator_pitch(mirror::Union{PDM,MMDM})
    return mirror.actuator_pitch
end

"""
    num_actuators(mirror::DeformableMirror) -> Int

Returns the number of actuators in the given deformable mirror.

# Example
```julia
num = num_actuators(PDM30_37)
```
"""
function num_actuators(mirror::DeformableMirror)
    return error(
        "Type $(typeof(mirror)) of the mirror doesn't define the number of actuators"
    )
end

function num_actuators(mirror::PDM)
    return length(mirror.actuator_positions)
end

function num_actuators(mirror::MMDM)
    return length(mirror.actuator_polygons)
end

"""
    actuators(mirror::DeformableMirror) -> Vector

Returns an array of actuators for the given deformable mirror.

# Example
```julia
actuators_array = actuators(PDM30_37)
```
"""
function actuators(mirror::PDM)::Vector{Point2}
    return mirror.actuator_positions
end

function actuators(mirror::MMDM)::Vector{Polygon}
    return mirror.actuator_polygons
end
