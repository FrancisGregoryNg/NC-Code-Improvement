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
function [actualConnections] = rectify(finalSequence,blockConnections,block,distance)
%{
Objective: Rectify the final sequences to utilize actual connection points.

Input:
    finalSequence = the final sequence to be used for the improved NC code
    blockConnections = the globalConnectionList indices of the closest
        connection points between two blocks
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
    distance = the distance matrix
Output:
    actualConnections = the actual connection points to be used in the
        final sequence; the points where the previous block will connect to
        the current block
%}
%% Initialize
actualConnections=zeros(1,length(block));
connectionLength=0;
%% Rectify
x=0;
while x<length(finalSequence(:))
    x=x+1;
    if x==1, t=finalSequence(length(block)); else t=finalSequence(x-1); end
    u=finalSequence(x);
    if x==length(block), v=finalSequence(1); else v=finalSequence(x+1); end
    if isequal(block(u).curveType,'point') 
        actualConnections(x)=block(u).globalListIndices; 
        option1=distance(blockConnections.from(t,u),actualConnections(x))+distance(actualConnections(x),blockConnections.to(u,v));
        connectionLength=connectionLength+option1;
    end
    if isequal(block(u).curveType,'closed')
        option1=distance(blockConnections.from(t,u),blockConnections.to(t,u))+distance(blockConnections.to(t,u),blockConnections.to(u,v));      %length when both blocks connect to the closest connection point with the previous block
        option2=distance(blockConnections.from(t,u),blockConnections.from(u,v))+distance(blockConnections.from(u,v),blockConnections.to(u,v));  %length when both blocks connect to the closest connection point with the next block
        if option1<option2, actualConnections(x)=blockConnections.to(t,u); connectionLength=connectionLength+option1; 
        else actualConnections(x)=blockConnections.from(u,v); connectionLength=connectionLength+option2; 
        end
    end
    if isequal(block(u).curveType,'open')
        option1=distance(blockConnections.from(t,u),block(u).globalListIndices(1))+distance(block(u).globalListIndices(2),blockConnections.to(u,v));  %length when previous block connects to first connection point, and the next block connects to the second connection point
        option2=distance(blockConnections.from(t,u),block(u).globalListIndices(2))+distance(block(u).globalListIndices(1),blockConnections.to(u,v));  %length when next block connects to first connection point, and the previous block connects to the second connection point
        if option1<option2, actualConnections(x)=block(u).globalListIndices(1); connectionLength=connectionLength+option1; 
        else actualConnections(x)=block(u).globalListIndices(2); connectionLength=connectionLength+option2; 
        end
    end 
end 
end