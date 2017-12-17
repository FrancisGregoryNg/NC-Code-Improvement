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
function [blockConnections] = blockDistance(block,distance)
%{
Objective: Get the closest connection points between each pair of blocks.
  
Input:
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
    distance = the distance matrix for all candidate connection points of
        all blocks as found in the globalConnectionList
Output:
    blockConnections = contain the index value in the globalConnectionList 
        for the closest pair of connection points between two blocks, based
        on the linear distance. It is a structure containing two fields, 
        'from' and 'to', each containing an array. The value in the cell for 
        both arrays is accessed with the row corresponding to the 'from' 
        block and the column corresponding to the 'to' block. In the 'from' 
        field, the cell value is the index in the globalConnectionList for 
        the 'from' block. Similarly, in the 'to' field, the cell value is 
        the index in the globalConnectionList for the 'to' block.
        Example: 
            block(1).globalListIndices=[1,2,3,4]
            block(2).globalListIndices=[5,6,7]
            blockConnections.from(1,2) = 3
            blockConnections.to(1,2) = 5
        This means that the closest pair of points is 3 and 5 (consult
        globalConnectionList for the [x y] values, or distance for the 
        distance between the two points) So if block 1 is connected to 
        block 2 in the milling sequence, they will be connected using these 
        points.
%}
%% Initialize Arrays
blockConnections.from=zeros(length(block));
blockConnections.to=zeros(length(block));
%% Populate Arrays
from=0;
while from<length(block)
    from=from+1;
    to=from;
    while to<length(block)
        to=to+1;
        minimum=min(min(distance(block(from).globalListIndices,block(to).globalListIndices)));                      % the first min gives a row vector for minimum values of each column, second min gives the minimum value for the entire array selection
        [row,column]=find(distance(block(from).globalListIndices,block(to).globalListIndices)==minimum,1,'first');  % get the indices from the array selection for the minimum value previously obtained, limit to one find
        blockConnections.from(from,to)=block(from).globalListIndices(1)-1+row;  %first candidate connection value of 'from' block is offset by one to start from outside of the array selection, adding the row index in the selection results in the actual index in the distance matrix 
        blockConnections.to(to,from)=blockConnections.from(from,to);            %reflection means that the second array is redundant, but allows for more convenient calling
        blockConnections.to(from,to)=block(to).globalListIndices(1)-1+column;   %similar process for 'to' block
        blockConnections.from(to,from)=blockConnections.to(from,to);            
    end
end
%% Eliminate Distance Value to the Block Itself
x=0;
while x<length(block)
    x=x+1;
    blockConnections.from(x,x)=inf;
    blockConnections.to(x,x)=inf;
end
end