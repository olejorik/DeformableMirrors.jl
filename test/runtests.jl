using DeformableMirrors
using Test
using GeometryBasics: Point2, Polygon

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

    # Check if the actuators are sorted clockwise starting from the center
    center = (0.0, 0.0)
    angles = [atan(p[2] - center[2], p[1] - center[1]) for p in actuators[2:end]]
    @test angles == sort(angles)

    # Check if the distance between layers is correct
    distances = [sqrt((p[1] - center[1])^2 + (p[2] - center[2])^2) for p in actuators]
    unique_distances = sort(unique(round.(distances, digits=2)))
    @test isapprox(unique_distances, [0.0, pitch, 2 * pitch, 3 * pitch]; atol=1e-6)
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
