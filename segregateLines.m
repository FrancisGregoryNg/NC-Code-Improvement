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
function [line] = segregateLines(codeArray)
%{
Objective: Structure the data from the lines of code based on the pertinent
    letter addresses.
  
Input:     
    codeArray = cell array of strings that each contains lines of code
Output:    
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
%}
%% Initialize Line Structure
sample.N=[];
sample.M=[];
sample.G=[];
sample.X=[];
sample.Y=[];
sample.Z=[];
sample.I=[];
sample.J=[];
sample.K=[];
sample.F=[];
line=repmat(sample,length(codeArray),1);
%% Populate Line Structure
n=1;
while n<=length(codeArray)     
    [values,labels]=stringParser(codeArray{n});
    x=1;
    while x<=length(labels)
        if labels{x}=='N', line(n).N=str2double(values{x}); end
        if labels{x}=='M', line(n).M=str2double(values{x}); end
        if labels{x}=='G', line(n).G=str2double(values{x}); end
        if labels{x}=='X', line(n).X=str2double(values{x}); end
        if labels{x}=='Y', line(n).Y=str2double(values{x}); end
        if labels{x}=='Z', line(n).Z=str2double(values{x}); end
        if labels{x}=='I', line(n).I=str2double(values{x}); end
        if labels{x}=='J', line(n).J=str2double(values{x}); end
        if labels{x}=='K', line(n).K=str2double(values{x}); end
        if labels{x}=='F', line(n).F=str2double(values{x}); end
        x=x+1;
    end
    n=n+1;
end
end