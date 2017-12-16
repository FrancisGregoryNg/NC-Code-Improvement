function [plungeRate,feedRate] = getFValues(line)
%{
Objective: Determine the plunge rate and the feed rate from the F values.
    If the F values are not consistent to just two values, the default 
    rates will be used.

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
    plungeRate = the speed in which the tool plunges into the material
    feedRate = the speed in which the tool moves above the material, cuts 
        through the material, or retracts from the material.     
%}
%% Default Values
plungeRate = 100;
feedRate = 200;
%% Gather F Values
F=line(1).F;
n=2;
while n<=length(line)
    F=vertcat(F,line(n).F);
    n=n+1;
end
%% Determine the Feed Rate and Rapid Rate
uniqueFValue=unique(F,'sorted');
if length(uniqueFValue)==2
    plungeRate = uniqueFValue(1);
    feedRate = uniqueFValue(2);
end
end