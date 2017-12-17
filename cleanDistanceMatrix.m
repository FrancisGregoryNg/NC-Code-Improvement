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
function [distance] = cleanDistanceMatrix(distance,block)
%{
Objective: Eliminate distance values for connections within the same block.  

Input:
    distance = the distance matrix
    block = the structured block data
        where:
            block.indices = the line structure indices of the lines of code 
                contained within the block
            block.curveType = the type of block: 'point', 'open' contour, 
                or 'closed' contour
            block.connectionPoints = the [x y] values of the candidate
                connection points for the block to be connected to other
                blocks
            block.connectionIndices = the line structure indices of the
                lines containing the connection points
            block.globalListIndices = the global list indices of the
                connection points
            block.length = the length of the contour described by the lines
                of code contained within the block
Output:
     distance = the cleaned distance matrix
%}
%% Clean Distance Matrix
n=0;
while n<length(block)
    n=n+1;
    x=0;
    while x<length(block(n).globalListIndices)
        x=x+1;
        q=x-1;
        while q<length(block(n).globalListIndices)  
            q=q+1;
            distance(block(n).globalListIndices(x),block(n).globalListIndices(q))=inf;  
            distance(block(n).globalListIndices(q),block(n).globalListIndices(x))=inf;
        end
    end
end
end