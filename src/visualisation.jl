"""
    pdmplot(pdm, controls=zeros(Float64, num_actuators(pdm)); kwargs...)

Visualize a Piezoelectric Deformable Mirror (PDM) with optional control values.

# Arguments
- `pdm`: PDM object to visualize
- `controls`: Vector of control values for each actuator, determining their colors.
  Must be the same length as the number of actuators. Default is zeros.

# Keyword Arguments
- `show_numbers::Bool=false`: Whether to display actuator numbers
- `title::String="PDM Visualization"`: Title of the plot
- `colormap=:coolwarm`: Colormap for mapping control values to colors
- `clip_low_color=:blue`: Color for actuators with values below `colorrange[1]`
- `clip_high_color=:red`: Color for actuators with values above `colorrange[2]`
- `colorrange=(-1.0, 1.0)`: Range of control values mapped to the full colormap
- `markersize=30`: Size of the markers representing actuators

# Returns
A tuple of `(fig, ax, plot)` where:
- `fig`: The Figure object
- `ax`: The Axis object
- `plot`: The PDMPlot object

# Example
```julia
# Basic visualization with default settings
fig, ax, plot = pdmplot(PDM30_37)

# Visualization with control values and custom settings
controls = rand(num_actuators(PDM30_37)) .* 2 .- 1  # Random values between -1 and 1
fig, ax, plot = pdmplot(PDM30_37, controls; 
                        show_numbers=true, 
                        colormap=:viridis, 
                        colorrange=(-0.5, 0.5))
```
"""
function pdmplot end

"""
    pdmplot!(ax, pdm, controls=zeros(Float64, num_actuators(pdm)); kwargs...)

Add a Piezoelectric Deformable Mirror (PDM) visualization to an existing axis.

See [`pdmplot`](@ref) for full documentation of parameters and keyword arguments.
"""
function pdmplot! end

"""
    mmdmplot(mmdm, controls=zeros(Float64, num_actuators(mmdm)); kwargs...)

Visualize a Micro-Machined Deformable Mirror (MMDM) with optional control values.
The actuators are displayed as hexagonal polygons colored according to their control values.

# Arguments
- `mmdm`: MMDM object to visualize
- `controls`: Vector of control values for each actuator, determining their colors.
  Must be the same length as the number of actuators. Default is zeros.

# Keyword Arguments
- `show_numbers::Bool=false`: Whether to display actuator numbers
- `title::String="MMDM Visualization"`: Title of the plot
- `colormap=:coolwarm`: Colormap for mapping control values to colors
- `clip_low_color=:blue`: Color for actuators with values below `colorrange[1]`
- `clip_high_color=:red`: Color for actuators with values above `colorrange[2]`
- `colorrange=(-1.0, 1.0)`: Range of control values mapped to the full colormap
- `linewidth=1.0`: Width of the stroke lines around polygons

# Returns
A tuple of `(fig, ax, plot)` where:
- `fig`: The Figure object
- `ax`: The Axis object
- `plot`: The MMDMPlot object

# Example
```julia
# Basic visualization with default settings
fig, ax, plot = mmdmplot(MMDM15_37)

# Visualization with control values and custom settings
controls = rand(num_actuators(MMDM15_37)) .* 2 .- 1  # Random values between -1 and 1
fig, ax, plot = mmdmplot(MMDM15_37, controls; 
                         show_numbers=true, 
                         colormap=:viridis, 
                         colorrange=(-0.5, 0.5))
```
"""
function mmdmplot end

"""
    mmdmplot!(ax, mmdm, controls=zeros(Float64, num_actuators(mmdm)); kwargs...)

Add a Micro-Machined Deformable Mirror (MMDM) visualization to an existing axis.

See [`mmdmplot`](@ref) for full documentation of parameters and keyword arguments.
"""
function mmdmplot! end
