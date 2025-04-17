using GeometryBasics

export hexagonal_grid, hexagon, hexagonal_grid_hexnums, regular_hexagon, honeycomb_hexagons

"""
    hexagonal_grid(rows, cols, pitch)

Generate a hexagonal grid of points with the given number of rows, columns, and pitch.
"""
function hexagonal_grid(rows::Int, cols::Int, pitch::Float64)
    points = Vector{Tuple{Float64,Float64}}()
    center_x = (cols - 1) * pitch / 2
    center_y = (rows - 1) * pitch * sqrt(3) / 4
    radius = (cols - 1) * pitch / 2

    for row in 1:rows
        for col in 1:cols
            x = (col - 1) * pitch
            y = (row - 1) * pitch * sqrt(3) / 2
            if isodd(row)
                x += pitch / 2
            end
            # Only include points within the hexagonal radius
            if sqrt((x - center_x)^2 + (y - center_y)^2) <= radius
                push!(points, (x, y))
            end
        end
    end
    return points
end

"""
    hexagonal_grid_hexnums(n, pitch; flat_topped=true, clockwise=true)

Generate a true hexagonal grid with n layers around the center.
Each point has exactly six equidistant neighbors, forming a regular hexagonal pattern.
All layers are properly centered around (0,0).
Points are ordered starting from the center, then proceeding outward layer by layer.
Within each layer, points can be optionally sorted clockwise.

# Arguments
- `n`: Number of layers around the central point.
- `pitch`: Distance between adjacent points.
- `flat_topped`: Whether the hexagons are flat-topped (true) or pointy-topped (false).
- `clockwise`: Whether to sort points clockwise within each layer.

# Returns
A vector of coordinate tuples representing points in the hexagonal grid,
ordered from center outward.

# Example
```julia
grid = hexagonal_grid_hexnums(3, 1.0)
```
"""
function hexagonal_grid_hexnums(n::Int, pitch::Float64; flat_topped=true, clockwise=true)
    # Create a dictionary to group points by layer
    points_by_layer = Dict{Int,Vector{Tuple{Float64,Float64}}}()

    # Initialize with the center point
    points_by_layer[0] = [(0.0, 0.0)]

    # Using cube coordinates (q, r, s) where q + r + s = 0
    for q in (-n):n
        for r in max(-n, -q - n):min(n, -q + n)
            # Calculate s to satisfy q + r + s = 0
            s = -q - r

            # Determine the layer (distance from origin in cube coordinates)
            layer = max(abs(q), abs(r), abs(s))

            # Skip the center point (already added)
            if layer == 0
                continue
            end

            # Check if this point is within n steps from origin
            if layer <= n
                # Convert cube coordinates to Cartesian
                # Simplified expressions for better readability and efficiency
                if flat_topped
                    x = pitch * (sqrt(3) / 2 * q)
                    y = pitch * (0.5 * q + r)
                else
                    x = pitch * (q + 0.5 * r)
                    y = pitch * (sqrt(3) / 2 * r)
                end

                # Add to the appropriate layer
                if !haskey(points_by_layer, layer)
                    points_by_layer[layer] = Vector{Tuple{Float64,Float64}}()
                end
                push!(points_by_layer[layer], (x, y))
            end
        end
    end

    # Sort points within each layer if requested
    if clockwise
        center = (0.0, 0.0)
        for layer in keys(points_by_layer)
            if layer > 0  # Skip center point
                sort!(
                    points_by_layer[layer]; by=p -> atan(p[2] - center[2], p[1] - center[1])
                )
            end
        end
    end

    # Combine all points in order of increasing layer
    ordered_points = Vector{Tuple{Float64,Float64}}()
    for layer in sort(collect(keys(points_by_layer)))
        append!(ordered_points, points_by_layer[layer])
    end

    return ordered_points
end

"""
    hexagon(center, radius)

Generate the vertices of a hexagon centered at `center` with the given `radius`.
"""
function hexagon(center::Tuple{Float64,Float64}, radius::Float64)
    cx, cy = center
    vertices = [(cx + radius * cos(θ), cy + radius * sin(θ)) for θ in 0:(π / 3):(2π)]
    return vertices
end

"""
    regular_hexagon(center, inradius)

Generate a regular hexagon as a Polygon, centered at `center` with the given `inradius` (distance from center to middle of each side).
This creates a flat-sided hexagon (with a flat edge on top and bottom).
"""
function regular_hexagon(center::Tuple{Float64,Float64}, inradius::Float64)
    cx, cy = center
    vertices = Vector{Point2{Float64}}()
    
    # Create a flat-top hexagon (flat sides on top and bottom)
    # Start from the top-right vertex and go clockwise
    for i in 0:5
        angle = 2π * i / 6 + π/2  # Start at π/2 for flat top (first point is at top-right)
        x = cx + inradius / cos(π/6) * cos(angle)  # Circumradius = inradius / cos(π/6)
        y = cy + inradius / cos(π/6) * sin(angle)
        push!(vertices, Point2{Float64}(x, y))
    end
    return Polygon(vertices)
end

"""
    honeycomb_hexagons(n, pitch, gap)

Generate a honeycomb grid of regular hexagons with n layers.
Each hexagon is flat-topped (one edge on top).

# Arguments
- `n`: Number of layers around the central hexagon.
- `pitch`: Distance between adjacent hexagon centers.
- `gap`: Gap between adjacent hexagon edges.

# Returns
A vector of Polygons representing the hexagons in the honeycomb grid.
"""
function honeycomb_hexagons(n::Int, pitch::Float64, gap::Float64)
    # Calculate the circumradius (center to vertex distance)
    # For a regular hexagon, if we want the distance between centers to be 'pitch',
    # and the gap between adjacent hexagons to be 'gap'
    
    # In a honeycomb arrangement with flat-topped hexagons:
    # - Distance between centers is 'pitch'
    # - The circumradius for touching hexagons would be pitch/2
    # - We need to reduce this to create a gap
    
    # Calculate the side length needed to maintain the specified gap
    side_length = (pitch - gap) / sqrt(3)
    
    # Get the centers of the hexagons using the existing hexagonal grid function
    # Use flat_topped=true to get proper orientation for honeycomb pattern
    centers = hexagonal_grid_hexnums(n, pitch; flat_topped=true)
    
    # Generate a polygon for each center point
    hexagons = Vector{Polygon}()
    
    for center in centers
        # For each center, create a hexagon with the calculated dimensions
        vertices = Vector{Point2{Float64}}()
        
        # Create a flat-topped hexagon (pointy sides)
        for i in 0:5
            angle = 2π * i / 6
            x = center[1] + side_length * cos(angle)
            y = center[2] + side_length * sin(angle)
            push!(vertices, Point2{Float64}(x, y))
        end
        
        push!(hexagons, Polygon(vertices))
    end
    
    return hexagons
end
