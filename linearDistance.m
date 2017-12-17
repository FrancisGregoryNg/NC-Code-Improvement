%%Copyright 2017 UON Leapheng, Calvin Ng, Francis Ng, Sharaful-Ilmi Paduman
%
%  This file is part of NC-Code-Improvement.
%
%    NC-Code-Improvement is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    NC-Code-Improvement is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with NC-Code-Improvement.  If not, see <http://www.gnu.org/licenses/>.
%%
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