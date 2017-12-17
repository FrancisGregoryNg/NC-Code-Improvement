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
function [block] = generateBlocks(line,height,depth)
%{
Objective: Identify the blocks from the lines based on the continuity of
    operations with the Z value equal to the cutting depth. Blocks are
    classified into curve types which are 'point', 'open' contour, and
    'closed' contour. Then, the inter-block connection points are 
    identified and the total length of each block is calculated.
  
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
    height = the level at which the tool hovers over the material during
        rapid movement
    neutral = the level to which the tool descends right before plunging
    depth = the level at which the tool cuts through the material
Output:
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
%}
%% Count the Number of Blocks
numberOfBlocks=0;
startBlock=0;
n=0;
while n<length(line)
   n=n+1;
   if ~isempty(line(n).Z)   
       if line(n).Z==height, startBlock=1; end
       if (startBlock==1)&&(line(n).Z==depth), numberOfBlocks=numberOfBlocks+1; startBlock=0; end
       %if line(n).Z==neutral, NumberOfBlocks=NumberOfBlocks+1; end   %alternative method
   end
end
%% Initialize Block Structure
sample.indices=[];
sample.curveType=[];
sample.connectionPoints=[];
sample.connectionIndices=[];
sample.globalListIndices=[];
sample.length=[];
block=repmat(sample,numberOfBlocks+1,1);
%% Collect Consecutive Points at Cutting Depth into Blocks
n=0;
while n<length(line)
    n=n+1;
    if ~isempty(line(n).Z), block(1).indices=n; break; end   %ignore all lines without a Z value (the initial comment lines), record home position as the first block (just a point)
end
x=2;  %block(2) onwards contain lines that work on the cutting depth, exclude retract and plunge lines
while n<length(line)
    n=n+1;
    if ~isempty(line(n).Z)
        if line(n).Z==depth, block(x).indices=vertcat(block(x).indices,n); end   
        if (line(n).Z==height)&&(line(n-1).Z==depth), x=x+1; end
    end
end
%% Classify Block Curve Types by the Number of Indices, and the Starting and Ending [x y] Values
x=0;  
while x<length(block)
    x=x+1;
    if length(block(x).indices)==1, block(x).curveType='point'; continue; end
    if (line(block(x).indices(1)).X==line(block(x).indices(end)).X)&&(line(block(x).indices(1)).Y==line(block(x).indices(end)).Y), 
        block(x).curveType='closed'; 
    else
        block(x).curveType='open';
    end
end
%% List the Line Indices for Possible Connection Points Based on the Block Curve Type
x=0;  
while x<length(block)
    x=x+1;
    if isequal(block(x).curveType,'point'), block(x).connectionIndices=block(x).indices; continue; end
    if isequal(block(x).curveType,'closed'), block(x).connectionIndices=block(x).indices(1:end-1); continue; end
    if isequal(block(x).curveType,'open'), block(x).connectionIndices=[block(x).indices(1);block(x).indices(end)]; continue; end
end
%% List the [x y] Values Corresponding to the Possible Connection Points
x=0;
while x<length(block)
    x=x+1;
    n=0;
    while n<length(block(x).connectionIndices)
        n=n+1;
        q=block(x).connectionIndices(n);
        block(x).connectionPoints=vertcat(block(x).connectionPoints,[line(q).X,line(q).Y]);
    end
end
%% Calculate the Total Length of the Block
x=0;  
while x<length(block)
    x=x+1;
    if isequal(block(x).curveType,'point'), block(x).length=0; continue; end
    block(x).length=0;
    n=1;
    while n<length(block(x).indices)
        n=n+1;
        q=block(x).indices(n);
        if (line(q).G==0)||(line(q).G==1), block(x).length=block(x).length+linearDistance(line,q); continue; end
        if (line(q).G==2)||(line(q).G==3), block(x).length=block(x).length+circularDistance(line,q); continue; end 
    end 
end
%% Sequentially Assign Index Calues for All the Candidate Connection Points
q=0;
x=0; 
while x<length(block)
    x=x+1;
    n=0;
    while n<length(block(x).connectionIndices)
        n=n+1;
        q=q+1;
        block(x).globalListIndices(n)=q;
    end 
end
end