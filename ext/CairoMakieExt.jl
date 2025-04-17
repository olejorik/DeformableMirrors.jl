module CairoMakieExt
using CairoMakie
using DeformableMirrors

#= 
using GeometryBasics: Point2, Circle, decompose
using DeformableMirrors

import DeformableMirrors: pdmplot, pdmplot!

# Define a plotting recipe for PDM
@recipe(PDMPlot, pdm) do scene
    Attributes(; show_numbers=false, title="PDM Visualization")
end

function Makie.plot!(plot::PDMPlot)
    pdm = plot[1]

    # Extract actuator positions
    positions = pdm[].actuator_positions
    x_coords = [p[1] for p in positions]
    y_coords = [p[2] for p in positions]



    # Plot actuators
    scatter!(plot, x_coords, y_coords; markersize=10, color=:blue, label="Actuators")
    ax = current_axis()
    ax.aspect = DataAspect()


    # Optionally show actuator numbers
    if plot[:show_numbers][]
        for (i, (x, y)) in enumerate(zip(x_coords, y_coords))
            text!(ax, x, y; text="$i", align=(:center, :top), color=:black, offset=(0, -6))
        end
    end

    # Plot full aperture as a circle
    full_aperture_radius = pdm[].full_aperture / 2.0
    circle_full = Circle(Point2(0.0, 0.0), full_aperture_radius)
    lines!(
        ax, decompose(Point2, circle_full); color=:red, linewidth=2, label="Full Aperture"
    )

    # # Plot working aperture as a circle
    working_aperture_radius = working_aperture(pdm[]) / 2.0
    circle_working = Circle(Point2(0.0, 0.0), working_aperture_radius)
    lines!(
        ax,
        decompose(Point2, circle_working);
        color=:green,
        linewidth=2,
        linestyle=:dash,
        label="Working Aperture",
    )
    axislegend(ax) # doesnt work for some reason
    @show plot.plots

    return plot
end
 =#
# Define a plotting recipe for MMDM
# @recipe function f(::Type{<:AbstractPlot}, mmdm::MMDM)
#     polygons = mmdm.actuator_polygons
#     return (; polygons)
# end

# export pdmplot, pdmplot!


end
