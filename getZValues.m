function [Z,height,neutral,depth] = getZValues(line)
%{
Objective: Determine the height, neutral, and depth levels from the Z 
    values. If the Z values are not consistent to just three values, the 
    default levels will be used.

Input: 
    line = the structured line data
        where:
            line.N = line number
            line.M = M-code, for starting and ending the program, among
                other purposes
            line.G = G-code, for the type of tool movement
            line.X = X-coordinate of destination, absolute coordinates
            line.Y = Y-coordinate of destination, absolute coordinates
            line.Z = Z-coordinate of destination, absolute coordinates
            line.I = X-coordinate of circular center, absolute coordinates
            line.J = Y-coordinate of circular center, absolute coordinates
            line.K = Z-coordinate of circular center, absolute coordinates
            line.F = feed rate   
Output: 
    height = the level at which the tool hovers over the material during
        rapid movement
    neutral = the level to which the tool descends right before plunging
    depth = the level at which the tool cuts through the material  
%}
%% Default Values
depth = -1;
neutral = 0.1;
height = 1;
%% Gather Z Values
Z=line(1).Z;
n=2;
while n<=length(line)
    Z=vertcat(Z,line(n).Z);
    n=n+1;
end
%% Determine Depth, Neutral, and Height
uniqueZValue=unique(Z,'sorted');
if length(uniqueZValue)==3
    depth = uniqueZValue(1);
    neutral = uniqueZValue(2);
    height = uniqueZValue(3);
end
end