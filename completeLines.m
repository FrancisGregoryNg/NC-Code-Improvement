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
function [line] = completeLines(line)
%{
Objective: Complete the line structure data by using implicitly-defined
    values which are found in preceding lines.
  
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
    line = the completed structured line data
%}
%% Default Values
gBefore=[];
xBefore=0;
yBefore=0;
zBefore=0;
fBefore=[];
%% Fill Structure with Implicitly-Defined Values from Previous Lines
n=0;
while n<length(line)
    n=n+1;      
    if isempty(line(n)), continue; end
    if line(n).G==5, gBefore=line(n).G; continue; end
    if ~isempty(line(n).M)
        if (line(n).M==3)||(line(n).M==4), program=1; end
        if line(n).M==2, program=0; end
        continue;
    end
    if isempty(line(n).G)
        if gBefore~=5, line(n).G=gBefore; else continue; end 
    else    
        gBefore=line(n).G;
    end
    if line(n).G==0||line(n).G==1||line(n).G==2||line(n).G==3
        if isempty(line(n).X), line(n).X=xBefore; else xBefore=line(n).X; end
        if isempty(line(n).Y), line(n).Y=yBefore; else yBefore=line(n).Y; end
        if isempty(line(n).Z), line(n).Z=zBefore; else zBefore=line(n).Z; end
    end
    if isempty(line(n).F), line(n).F=fBefore; else fBefore=line(n).F; end
end
end