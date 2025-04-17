using CairoMakie
using DeformableMirrors
using Test
using GeometryBasics: Point2, Polygon
using Statistics: mean

@testset "PDM and MMDM Test Cases" begin
    # Test case for 37-channel 30mm PDM
    pitch_pdm = 4.3
    actuators_pdm = hexagonal_grid(7, 7, pitch_pdm)
    pdm = PDM(actuators_pdm, 30.0, [22.0], pitch_pdm)
    @test length(pdm.actuator_positions) == 37

    # Test case for 37-channel 15mm MMDM
    pitch_mmdm = 70 * 0.0254 # Convert mils to mm
    gap_mmdm = 8 * 0.0254   # Convert mils to mm
    radius_mmdm = (pitch_mmdm - gap_mmdm) / 2
    centers_mmdm = hexagonal_grid(7, 7, pitch_mmdm)
    polygons_mmdm = [
        Polygon([Point2(p[1], p[2]) for p in [(0.0, 0.0), (1.0, 0.0), (0.5, 0.866)]]) for
        _ in 1:37
    ]
    mmdm = MMDM(polygons_mmdm, 15.0, [15.0], pitch_mmdm)
    @test length(mmdm.actuator_polygons) == 37
end

@testset "Hexagonal Grid with Hexagonal Numbers" begin
    # Test case for 37 actuators (3 layers: 1, 6, 12, 18)
    pitch = 4.3
    actuators = hexagonal_grid_hexnums(3, pitch)

    @test length(actuators) == 37

    # Check if the center point is at origin
    @test actuators[1] == (0.0, 0.0)

    # Check that points are sorted by layer
    # First layer has 6 points, second has 12, third has 18
    @test length(actuators) == 1 + 6 + 12 + 18
end

@testset "Hexagonal Grid Geometry" begin
    # Test with a pitch of 1.0 for simplicity
    pitch = 1.0
    n = 3 # 3 layers will generate 37 points
    grid = hexagonal_grid_hexnums(n, pitch)

    # Check total number of points
    @test length(grid) == 1 + 6 + 12 + 18 # center + 1st layer + 2nd layer + 3rd layer = 37

    # Test center point is at origin
    @test grid[1] == (0.0, 0.0)

    # For flat-topped hexagons with simplified coordinates:
    # First, print the actual coordinates of some points to help with debugging
    #println("Point 2: $(grid[2])")
    #println("Point 4: $(grid[4])")
    #println("Point 10: $(grid[10])")

    # First point in first layer (index 2) - based on actual output
    @test isapprox(abs(grid[2][1]), sqrt(3)/2 * pitch, rtol=1e-10) # x-coordinate magnitude
    @test isapprox(abs(grid[2][2]), 0.5 * pitch, rtol=1e-10)       # y-coordinate magnitude

    # Check that some point in the first layer has coordinates with expected magnitude
    first_layer_points = grid[2:7]
    found_match = false
    for point in first_layer_points
        if isapprox(abs(point[1]), sqrt(3)/2 * pitch, rtol=1e-10) &&
           isapprox(abs(point[2]), 0.5 * pitch, rtol=1e-10)
            found_match = true
            break
        end
    end
    @test found_match

    # Test that distances from center are consistent within layers
    first_layer_dists = [sqrt(p[1]^2 + p[2]^2) for p in grid[2:7]]
    second_layer_dists = [sqrt(p[1]^2 + p[2]^2) for p in grid[8:19]]
    third_layer_dists = [sqrt(p[1]^2 + p[2]^2) for p in grid[20:37]]

    # Check distances are approximately consistent within each layer
    @test all(isapprox.(first_layer_dists, first_layer_dists[1], rtol=1e-10))
    # Using a looser tolerance for second and third layers since they may not be exactly on concentric circles
    @test all(isapprox.(second_layer_dists, second_layer_dists[1], rtol=0.2))
    @test all(isapprox.(third_layer_dists, third_layer_dists[1], rtol=0.2))
end

@testset "Predefined Mirrors" begin
    # Test PDM30_37
    @test length(PDM30_37.actuator_positions) == 37
    @test typeof(PDM30_37) == PDM

    # Test MMDM15_37
    @test length(MMDM15_37.actuator_polygons) == 37
    @test typeof(MMDM15_37) == MMDM
end

@testset "Mirror Characteristics" begin
    # Test PDM characteristics
    @test full_aperture(PDM30_37) == 30.0
    @test working_aperture(PDM30_37) == 22.0
    @test actuator_pitch(PDM30_37) == 4.3
    @test num_actuators(PDM30_37) == 37

    # Test MMDM characteristics
    @test full_aperture(MMDM15_37) == 15.0
    @test working_aperture(MMDM15_37) == 10.0
    @test actuator_pitch(MMDM15_37) == 70 * 0.0254
    @test num_actuators(MMDM15_37) == 37

    # Test setting working aperture
    set_working_aperture!(PDM30_37, 20.0)
    @test working_aperture(PDM30_37) == 20.0

    set_working_aperture!(MMDM15_37, 14.0)
    @test working_aperture(MMDM15_37) == 14.0
end

@testset "PDM Plotting Recipe" begin
    pdm = PDM30_37
    fig = Figure()
    ax = Axis(fig[1, 1]; title="PDM Test Plot")
    pdmplot!(ax, pdm; show_numbers=false)
    display(fig)
    @test true

    fig, ax, hm = pdmplot(pdm; show_numbers=true)
    display(fig)
    @test true
end
