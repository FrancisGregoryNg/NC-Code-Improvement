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
function [length] = circularDistance(line,n)
%{
Objective: Get the circular distance that the operation encoded on the line
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
    length = the circular distance
%}
%% Previous Point [x y]
A1=line(n-1).X;
A2=line(n).X;
%% Target Point [x y]
B1=line(n-1).Y;
B2=line(n).Y;
%% Center [i j]
I=line(n).I;
J=line(n).J;
%% Circular Direction
G=line(n).G;
%% Calculate Radius
R=sqrt((A1-I)^2+(B1-J)^2);  %note that the center [i j] is in absolute coordinates (not relative to the previous point [x y])
%% Calculate Angle
U=[(A1-I),(B1-J)];  %vector with starting point at center [i j]
V=[(A2-I),(B2-J)];
angle1=atan2(U(2),U(1));
angle2=atan2(V(2),V(1));
if angle1<0, angle1=2*pi+angle1; end %change angles from the interval [-pi,pi] to (0,2*pi]
if angle2<0, angle2=2*pi+angle2; end
if angle2>angle1
    if G==2, theta=2*pi-(angle2-angle1); end %clockwise direction
    if G==3, theta=angle2-angle1; end %counter-clockwise direction 
end
if angle2<angle1
    if G==2, theta=angle1-angle2; end %clockwise direction
    if G==3, theta=2*pi-(angle1-angle2); end %counter-clockwise direction
end
if angle2==angle1, theta=2*pi; end
%% Calculate Arc Length
length=abs(R*theta);
end