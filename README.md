## NURBS-based Hollow Cylinder Generator for LS-PrePost
This MATLAB script is designed to create a NURBS-based hollow cylinder geometry suitable for LS-PrePost simulations. The script reads input data from a specified file, allowing users to customize the cylinder's properties such as control points, order of the curve, inner radius, and thickness.

**Usage:**

**Modify Input Data:** Open the script and set the values of parameters such as c (control points), p_1 (order of curve), radius (inner radius), thickness, and other optional parameters.

**Run the Script:** Execute the script in MATLAB.

**Check Output:** The script generates an LS-PrePost compatible output file containing the NURBS-based hollow cylinder geometry.

**Optional Input Data:**
nisr: Interpolation nodes in the r direction
niss: Interpolation nodes in the s direction
nist: Interpolation nodes in the t direction

**Output:**
The script generates an LS-PrePost input file with the specified NURBS-based hollow cylinder geometry.

**Example:**
```MATLAB
% Set input parameters
c = 68;             % Control Points
p_1 = 2.0;          % Order of curve
radius =  [];       % Enter Inner radius 
thickness = [];     % Enter thickness

param = ;           % Keyword on data file
infile = fopen('File_Name', 'r');

% ... (Additional parameters)

% Run the script
NURBS_Hollow_Cylinder_Generator;

% Check 'outer_race.k' for the resulting geometry
