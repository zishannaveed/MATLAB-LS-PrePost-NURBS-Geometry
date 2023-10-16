clear all
close all
clc

%=========================================================================%
%                                INPUT_DATA                               %
%=========================================================================%

c = 68;                  % Control Points

p_1 = 2.0;               % Order of curve
radius =  [];            % Enter Inner radius 
thickness = [];          % Enter thickness

param = ;                % Keyword on data file
infile = fopen('File_Name', 'r');

% Script used to generate the NURBS based hollow cylinder geometry 
% which is compatible for Ls-Prepost

% Optional Input data______________________________________________________
nisr = 5.0;              % Interpolation_nodes in r direction
niss = 2.0;              % Interpolation_nodes in s direction
nist = 2.0;              % Interpolation_nodes in t direction

% ========================================================================%
cellarray = textscan(infile, '%s');

% Extracting y and z coordinates from the input file
cellno_x = 3.0;
for i = 1:c
    cellno_x = cellno_x + 5;
    node_y(i) = str2num(cellarray{1}{cellno_x});
end

cellno_y = 5.0;
for j = 1:c
    cellno_y = cellno_y + 5;
    node_z(j) = str2num(cellarray{1}{cellno_y});
end

node_x = ones(1, length(radius) * (c + 1));
node_y(1, c + 1) = node_y(1);
node_z(1, c + 1) = node_z(1);

outfile = fopen('outer_race.k', 'w'); % Output file

fprintf(outfile, '*KEYWORD\n');
fprintf(outfile, '*PART\n');
fprintf(outfile, '$#                                                                         title\n');
fprintf(outfile, 'outer_race\n');
fprintf(outfile, '$#     pid     secid       mid     eosid      hgid      grav    adpopt      tmid\n');
fprintf(outfile, '%10s%10s%10s%10s', num2str(1), num2str(0), num2str(0), ...
    num2str(0));
fprintf(outfile, '%10s%10s%10s%10s\n', num2str(0), num2str(0), num2str(0), ...
    num2str(0));

% ELEMENTS_________________________________________________________________
if (length(radius) == 2)
    p_s = 1.0;
else
    p_s = 2.0;
end
if (length(thickness) == 2)
    p_t = 1.0;
else
    p_t = 2.0;
end

fprintf(outfile, '*ELEMENT_SOLID_NURBS_PATCH\n');
fprintf(outfile, '$#   npeid       pid       npr        pr       nps        ps       npt        pt\n');
fprintf(outfile, '%10s%10s', num2str(1), num2str(1));
fprintf(outfile, '%10s%10s%10s%10s%10s%10s\n', num2str(c + 1), num2str(p_1), ...
    num2str(length(radius)), num2str(p_s), num2str(length(thickness)), num2str(p_t));
fprintf(outfile, '$#     wfl      nisr      niss      nist     imass         -         -     idfne\n');
fprintf(outfile, '%10s%10s%10s%10s', num2str(1), num2str(nisr), ...
    num2str(niss), num2str(nist));
fprintf(outfile, '%10s%10s%10s%10s\n', num2str(0), num2str(0), ...
    num2str(0), num2str(0));
%  ========================================================================

% knot Vector
%  ========================================================================

cellno_u = param + 1;
for uu = 1:(c + 1) + p_1 + 1  % k = n + p + 1
    cellno_u = cellno_u + 1;
    uknot(uu) = str2num(cellarray{1}{cellno_u});
end
uknot_norm = uknot / uknot(end);

% ...

% (Code for eta and zeta vectors)

%  ========================================================================

% Element Connectivity
%  ========================================================================
fprintf(outfile, '$#      n1        n2        n3        n4        n5        n6        n7        n8\n');
element_1 = length(radius);
element_2 = length(thickness);
element = element_1 * element_2;       % total no. of curves
tot_nodes = 1:element * (c + 1);   % total number of nodes

% ...

% (Code for real_node_mat)

%  ========================================================================

% Weight Values
%  ========================================================================
cellno_w = 6;
for p = 1:c
    cellno_w = cellno_w + 5;
    node_w(p) = str2num(cellarray{1}{cellno_w});
end

% ...

% (Code for real_weight)

%  =======================================================================
fprintf(outfile, '*NODE\n');
fprintf(outfile, '$#   nid               x               y               z      tc      rc\n');

% NODES____________________________________________________________________
for m = 1:length(radius)
    yloc{m} = node_y * radius(m);
    zloc{m} = node_z * radius(m);
end
yloc_final = cell2mat(yloc)';
zloc_final = cell2mat(zloc)';

for n = 1:length(thickness)
    xloc{n} = node_x * thickness(n);
end
xloc_mat = cell2mat(xloc)';
xloc_final = reshape(xloc_mat, [], length(thickness));

nodenum = 0.0;
for p = 1:length(thickness)
    for q = 1:length(yloc_final)
        nodenum = nodenum + 1.0;
        fprintf(outfile, '%8s', num2str(nodenum));
        fprintf(outfile, '%16s%16s%16s', num2str(xloc_final(q, p)), ...
            num2str(yloc_final(q)), num2str(zloc_final(q)));
        fprintf(outfile, '       0       0\n');
    end
end

% __________________________________________________________________________
fprintf(outfile, '*END');
fclose(outfile);