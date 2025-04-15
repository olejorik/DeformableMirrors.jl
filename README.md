# DeformableMirrors

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://olejorik.github.io/DeformableMirrors.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://olejorik.github.io/DeformableMirrors.jl/dev)
[![Build Status](https://github.com/olejorik/DeformableMirrors.jl/workflows/CI/badge.svg)](https://github.com/olejorik/DeformableMirrors.jl/actions)
[![Coverage](https://codecov.io/gh/olejorik/DeformableMirrors.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/olejorik/DeformableMirrors.jl)

## Project Plan

This project implements deformable mirrors for adaptive optics systems. The key features include:

1. **Mirror Types**:
   - `PDM`: Piezoelectric Deformable Mirror with actuator positions represented as 2D points.
   - `MMDM`: Micro-Machined Deformable Mirror with actuator polygons represented as `GeometryBasics.Polygon`.

2. **Interface Functions**:
   - `full_aperture`: Returns the full aperture of the mirror.
   - `working_aperture`: Returns the working aperture of the mirror.
   - `set_working_aperture!`: Sets the working aperture of the mirror.
   - `actuator_pitch`: Returns the actuator pitch of the mirror.
   - `num_actuators`: Returns the number of actuators in the mirror.
   - `actuators`: Returns an array of actuators for the mirror.

3. **Predefined Mirrors**:
   - `PDM30_37`: A 30mm PDM with 37 actuators.
   - `MMDM15_37`: A 15mm MMDM with 37 actuators.

4. **Testing**:
   - Comprehensive test cases for all features, including predefined mirrors and interface functions.

5. **Documentation**:
   - Detailed docstrings for all types and functions, including examples.

This project leverages the `GeometryBasics` package for structured representation of points and polygons.

## Mirror Simulation

This project will also include simulation capabilities for deformable mirrors to model the phase correction introduced by the mirrors. The key features will include:

1. **Phase Correction Simulation**:
   - Simulate the phase correction introduced by `PDM` and `MMDM` mirrors.
   - Support for user-defined actuator control signals.

2. **Integration with Actuator Layouts**:
   - Use the actuator positions and polygons to compute the phase correction.
   - Ensure compatibility with existing mirror types and interface functions.

3. **Visualization of Simulated Phase**:
   - Provide tools to visualize the simulated phase correction.
   - Include options for 2D and 3D visualizations.

4. **Testing and Validation**:
   - Validate the simulation results against analytical solutions or experimental data.

5. **Documentation and Examples**:
   - Add examples demonstrating the simulation capabilities.
   - Include usage instructions in the package documentation.

# Visualization of Control Signals for Deformable Mirrors

This document outlines the plan to implement a visualization tool for control signals sent to deformable mirror actuators. The tool will be integrated into the `DeformableMirrors.jl` package and will support two types of mirrors: PDM and MMDM.

## Features

1. **Actuator Map Visualization**:
   - Display actuator positions for PDM as points and for MMDM as polygons.
   - Use colors to represent control voltages for each actuator.
   - Highlight voltages outside the range `[-1, 1]` as saturated.

2. **Customizable Visualization**:
   - Allow users to specify colormaps and saturation thresholds.
   - Provide options to overlay additional information, such as actuator indices or labels.

3. **Integration with `DeformableMirrors.jl`**:
   - Add the visualization as a module or function within the package.
   - Ensure compatibility with existing data structures for actuator geometries and control signals.

---

## Milestones

### 1. **Define Data Structures**
   - Extend or reuse existing data structures in `DeformableMirrors.jl` to represent:
     - Actuator positions (for PDM).
     - Actuator polygons (for MMDM).
     - Control voltage vectors.

### 2. **Implement Visualization for PDM**
   - Create a function `visualize_pdm_control`:
     - Input: Vector of control voltages, actuator positions, and optional colormap.
     - Output: A plot with actuator positions as points, colored by their control voltages.
     - Highlight saturated voltages with a distinct color or marker.

### 3. **Implement Visualization for MMDM**
   - Create a function `visualize_mmdm_control`:
     - Input: Vector of control voltages, actuator polygons, and optional colormap.
     - Output: A plot with actuator polygons filled with colors corresponding to their control voltages.
     - Highlight saturated voltages with a distinct color or pattern.

### 4. **Add Colormap and Saturation Handling**
   - Use a colormap (e.g., `:viridis` or `:coolwarm`) to map control voltages to colors.
   - Add a legend or colorbar to indicate the voltage-to-color mapping.
   - Implement logic to handle and visualize saturated voltages.

### 5. **Integrate with `DeformableMirrors.jl`**
   - Add the visualization functions to the `DeformableMirrors` module.
   - Ensure compatibility with existing actuator geometry definitions in the package.

### 6. **Testing and Validation**
   - Write unit tests to validate the visualization functions.
   - Test with real and synthetic data for both PDM and MMDM mirrors.

### 7. **Documentation**
   - Add usage examples and API documentation for the visualization functions.
   - Include visual examples in the package documentation.

### 8. **Optional Enhancements**
   - Add interactivity (e.g., zooming, panning, or hovering to display actuator details).
   - Support exporting visualizations to common image formats (e.g., PNG, SVG).

---

## Progress

### Completed Tasks (April 15, 2025)

1. **Updated README**:
   - Added a detailed project plan summarizing key features and structure.
   - Included a visualization plan with milestones for actuator layouts and interactive plots.

2. **Implemented Mirror Types**:
   - `PDM` and `MMDM` types with structured representations using `GeometryBasics.Point2` and `GeometryBasics.Polygon`.

3. **Developed Interface Functions**:
   - Functions for accessing and modifying mirror characteristics (`full_aperture`, `working_aperture`, `set_working_aperture!`, `actuator_pitch`, `num_actuators`, `actuators`).

4. **Predefined Mirrors**:
   - Added `PDM30_37` and `MMDM15_37` constants for easy access to common mirror configurations.

5. **Testing**:
   - Comprehensive test cases for all features, including predefined mirrors and interface functions.
   - Validated changes with successful test runs.

6. **Documentation**:
   - Added docstrings with examples for all types and functions.

### Next Steps

- Begin implementing visualization features as outlined in the milestones.
- Integrate visualizations into the test suite.
- Expand documentation with visualization examples.

---

## Example Usage

```julia
using DeformableMirrors

# Example for PDM
actuator_positions = [(x, y) for x in 1:10, y in 1:10]
control_voltages = randn(100)  # Random voltages
visualize_pdm_control(control_voltages, actuator_positions; colormap=:viridis)

# Example for MMDM
actuator_polygons = [Polygon(...) for i in 1:37]  # Define actuator polygons
control_voltages = randn(37)  # Random voltages
visualize_mmdm_control(control_voltages, actuator_polygons; colormap=:coolwarm)
