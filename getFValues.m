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