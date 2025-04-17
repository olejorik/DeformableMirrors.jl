module MakieExt

using Makie
using GeometryBasics: Point2, Circle, decompose, Polygon
using DeformableMirrors

import DeformableMirrors: pdmplot, pdmplot!, mmdmplot, mmdmplot!



# Define a plotting recipe for PDM
@recipe(PDMPlot, pdm, controls) do scene
    Attributes(
        show_numbers=false,
          title="PDM Visualization",
          colormap=:coolwarm,
          clip_low_color=:blue,
          clip_high_color=:red,
          colorrange=(-1.0, 1.0),
          markersize=30,
    )
end

function Makie.plot!(plot::PDMPlot)
    pdm = plot[1]
    controls = plot[2]
    colormap = plot[:colormap][]
    markersize = plot[:markersize][]
    colorrange = plot[:colorrange][]
    clip_low_color = plot[:clip_low_color][]
    clip_high_color = plot[:clip_high_color][]

    # Extract actuator positions
    positions = pdm[].actuator_positions
    x_coords = [p[1] for p in positions]
    y_coords = [p[2] for p in positions]



    # Plot actuators
    scatter!(plot, x_coords, y_coords; markersize=markersize, color=controls, 
    colormap = colormap, 
    colorrange = colorrange,
    lowclip = clip_low_color,
    highclip = clip_high_color,
    label="Actuators")
    ax = current_axis()
    ax.aspect = DataAspect()


    # Optionally show actuator numbers
    if plot[:show_numbers][]
        for (i, (x, y)) in enumerate(zip(x_coords, y_coords))
            text!(ax, x, y; text="$i", align=(:center, :top), color=:black, offset=(0, -markersize / 2))
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
    # @show plot.plots

    return plot
end

# Define a plotting recipe for MMDM
@recipe(MMDMPlot, mmdm, controls) do scene
    Attributes(
        show_numbers=false,
        title="MMDM Visualization",
        colormap=:coolwarm,
        clip_low_color=:blue,
        clip_high_color=:red,
        colorrange=(-1.0, 1.0),
        linewidth=1.0,
    )
end

function Makie.plot!(plot::MMDMPlot)
    mmdm = plot[1]
    controls = plot[2][]
    colormap = plot[:colormap][]
    colorrange = plot[:colorrange][]
    clip_low_color = plot[:clip_low_color][]
    clip_high_color = plot[:clip_high_color][]
    linewidth = plot[:linewidth][]
    
    # Get the actuator polygons
    polygons = mmdm[].actuator_polygons
    # @show polygons
    
    # Create axis with data aspect
    ax = current_axis()
    ax.aspect = DataAspect()
    
    # Map control values to the defined range for coloring
    min_cl, max_cl = colorrange
    controls_clipped = clamp.(controls, min_cl, max_cl)
    
    # Plot each actuator as a polygon with the control value as its color
    for (i, polygon) in enumerate(polygons)
        poly!(plot, polygon; 
            color=controls_clipped[i], 
            colormap=colormap, 
            colorrange=colorrange,
            strokewidth=linewidth,
            strokecolor=:black)
    end
    
    # # Highlight actuators that exceed limits
    low_idx = findall(<(min_cl), controls)
    high_idx = findall(>(max_cl), controls)
    
    # Draw polygons with clip colors for out-of-range actuators
    for i in low_idx
        poly!(ax, polygons[i]; 
            color=clip_low_color,
            strokewidth=linewidth*1.5, 
            strokecolor=:black)
    end
    
    for i in high_idx
        poly!(ax, polygons[i]; 
            color=clip_high_color,
            strokewidth=linewidth*1.5, 
            strokecolor=:black)
    end
    
    # Optionally show actuator numbers
    if plot[:show_numbers][]
        for (i, polygon) in enumerate(polygons)
            # Get the polygon vertices
            points = polygon.exterior
            
            # Calculate the centroid (average of all vertices)
            centroid_x = sum(p[1] for p in points) / length(points)
            centroid_y = sum(p[2] for p in points) / length(points)
            
            # Draw the text with high contrast
            text!(plot, 
                [centroid_x], 
                [centroid_y], 
                text=["$i"], 
                color=:black,
                align=(:center, :center),
                fontsize=14,
                # font="bold"
            )
        end
    end
    
    # Plot full aperture as a circle
    full_aperture_radius = mmdm[].full_aperture / 2.0
    circle_full = Circle(Point2(0.0, 0.0), full_aperture_radius)
    lines!(
        ax, decompose(Point2, circle_full); 
        color=:red, 
        linewidth=2, 
        label="Full Aperture"
    )
    
    # Plot working aperture as a circle
    working_aperture_radius = working_aperture(mmdm[]) / 2.0
    circle_working = Circle(Point2(0.0, 0.0), working_aperture_radius)
    lines!(
        ax,
        decompose(Point2, circle_working);
        color=:green,
        linewidth=2,
        linestyle=:dash,
        label="Working Aperture",
    )
    
    axislegend(ax)
    return plot
end

export pdmplot, pdmplot!, mmdmplot, mmdmplot!

end # module
