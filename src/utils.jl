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
    hexagonal_grid_hexnums(n, pitch; clockwise=true)

Generate a hexagonal grid based on hexagonal numbers (1, 7, 19, etc.) and arrange the actuators starting from the central one, going clockwise by default.
"""
function hexagonal_grid_hexnums(n::Int, pitch::Float64; clockwise=true)
    points = Vector{Tuple{Float64,Float64}}()
    center = (0.0, 0.0)
    push!(points, center) # Add the central point

    for layer in 1:n
        for i in 0:(6 * layer - 1)
            angle = 2π * i / (6 * layer)
            x = layer * pitch * cos(angle)
            y = layer * pitch * sin(angle)
            push!(points, (x, y))
        end
    end

    if clockwise
        points = sort(points; by=p -> atan(p[2] - center[2], p[1] - center[1]))
    end

    return points
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
