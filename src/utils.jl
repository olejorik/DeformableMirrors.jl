using GeometryBasics

export hexagonal_grid, hexagon, hexagonal_grid_hexnums

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
