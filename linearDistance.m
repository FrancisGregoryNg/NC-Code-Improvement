function [length] = linearDistance(line,n)
%{
Objective: Get the linear distance that the operation encoded on the line
    will make the tool traverse.

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
    n = the index in the structured line data (+1 of actual line number as 
        found in the NC file)
Output:
    length = the linear distance
%}
%% Previous Point [x y]
A1=line(n-1).X;
A2=line(n).X;
%% Target Point [x y]
B1=line(n-1).Y;
B2=line(n).Y;
%% Calculate Length
length=sqrt((A2-A1)^2+(B2-B1)^2); %use the linear distance formula based from the Pythagorean theorem
end