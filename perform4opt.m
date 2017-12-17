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
function [bestSequence] = perform4opt(initialSequence,blockConnections,distance)
%{
Objective: Find four random numbers in the sequence. These will split the
    sequence into four segments. Consider A, B, C, and D as the random
    numbers in ascending order. The first segment is the combination of the 
    values from the starting point (1) up to A, and the values from D+1 up 
    to the end point. The remaining segments are [A+1 to B], [B+1 to C],
    and [C+1 to D]. These three segments can be rearranged in 48 ways 
    relative to the fixed segment. All these possible ways, except for the 
    one which results in the same sequence as the original, are assessed 
    through the resulting cost and the altered sequence will be accepted 
    if it improves the cost.
    Note: The choice of the fixed segment solves the problem of the
        discontinuity at the ends of the sequence, and assures that the 
        first element of the sequence will always be 1.
  
Input:
    initialSequence = the input sequence of blocks
    initialCost = the cost of the initial sequence
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
    plungeRate = the speed in which the tool plunges into the material
    feedRate = the speed in which the tool moves above the material, cuts 
        through the material, or retracts from the material. 
    height = the level at which the tool hovers over the material during
        rapid movement
    neutral = the level to which the tool descends right before plunging
    depth = the level at which the tool cuts through the material
Output: 
    bestSequence = the improved sequence of blocks
    bestCost = the cost of the improved block sequence
%}
%% Initialize the Output
bestSequence=initialSequence;
bestCost=cost(initialSequence,blockConnections,distance);
%% Starting Criterion
if length(initialSequence)<(2*4), return; end
%% Dislocation Points
A=randi(length(initialSequence));
while (1)
    B=randi(length(initialSequence));
    if B~=A, break; end 
end
while (1)
    C=randi(length(initialSequence));
    if (C~=B)&&(C~=A), break; end 
end
while (1)
    D=randi(length(initialSequence));
    if (D~=C)&&(D~=B)&&(D~=A), break; end 
end
X=sort([initialSequence(A),initialSequence(B),initialSequence(C),initialSequence(D)]);
%% Segment Manipulation
segment12=X(1)+1:X(2);
segment23=X(2)+1:X(3);
segment34=X(3)+1:X(4);
last=length(initialSequence);
Y=0;
while Y<47
    Y=Y+1;
    currentSequence=1:X(1);
    if Y==00, currentSequence=horzcat(currentSequence, segment12      , segment23      , segment34       ); end %purposely ignore because it is just the same with the initial sequence
    if Y==01, currentSequence=horzcat(currentSequence, segment12      , segment23      , flip(segment34) ); end
    if Y==02, currentSequence=horzcat(currentSequence, segment12      , flip(segment23), segment34       ); end
    if Y==03, currentSequence=horzcat(currentSequence, segment12      , flip(segment23), flip(segment34) ); end
    if Y==04, currentSequence=horzcat(currentSequence, flip(segment12), segment23      , segment34       ); end
    if Y==05, currentSequence=horzcat(currentSequence, flip(segment12), segment23      , flip(segment34) ); end
    if Y==06, currentSequence=horzcat(currentSequence, flip(segment12), flip(segment23), segment34       ); end
    if Y==07, currentSequence=horzcat(currentSequence, flip(segment12), flip(segment23), flip(segment34) ); end
    if Y==08, currentSequence=horzcat(currentSequence, segment12      , segment34      , segment23       ); end
    if Y==09, currentSequence=horzcat(currentSequence, segment12      , segment34      , flip(segment23) ); end
    if Y==10, currentSequence=horzcat(currentSequence, segment12      , flip(segment34), segment23       ); end
    if Y==11, currentSequence=horzcat(currentSequence, segment12      , flip(segment34), flip(segment23) ); end
    if Y==12, currentSequence=horzcat(currentSequence, flip(segment12), segment34      , segment23       ); end
    if Y==13, currentSequence=horzcat(currentSequence, flip(segment12), segment34      , flip(segment23) ); end
    if Y==14, currentSequence=horzcat(currentSequence, flip(segment12), flip(segment34), segment23       ); end
    if Y==15, currentSequence=horzcat(currentSequence, flip(segment12), flip(segment34), flip(segment23) ); end
    if Y==16, currentSequence=horzcat(currentSequence, segment23      , segment12      , segment34       ); end
    if Y==17, currentSequence=horzcat(currentSequence, segment23      , segment12      , flip(segment34) ); end
    if Y==18, currentSequence=horzcat(currentSequence, segment23      , flip(segment12), segment34       ); end
    if Y==19, currentSequence=horzcat(currentSequence, segment23      , flip(segment12), flip(segment34) ); end
    if Y==20, currentSequence=horzcat(currentSequence, flip(segment23), segment12      , segment34       ); end
    if Y==21, currentSequence=horzcat(currentSequence, flip(segment23), segment12      , flip(segment34) ); end
    if Y==22, currentSequence=horzcat(currentSequence, flip(segment23), flip(segment12), segment34       ); end
    if Y==23, currentSequence=horzcat(currentSequence, flip(segment23), flip(segment12), flip(segment34) ); end
    if Y==24, currentSequence=horzcat(currentSequence, segment23      , segment34      , segment12       ); end
    if Y==25, currentSequence=horzcat(currentSequence, segment23      , segment34      , flip(segment12) ); end
    if Y==26, currentSequence=horzcat(currentSequence, segment23      , flip(segment34), segment12       ); end
    if Y==27, currentSequence=horzcat(currentSequence, segment23      , flip(segment34), flip(segment12) ); end
    if Y==28, currentSequence=horzcat(currentSequence, flip(segment23), segment34      , segment12       ); end
    if Y==29, currentSequence=horzcat(currentSequence, flip(segment23), segment34      , flip(segment12) ); end
    if Y==30, currentSequence=horzcat(currentSequence, flip(segment23), flip(segment34), segment12       ); end
    if Y==31, currentSequence=horzcat(currentSequence, flip(segment23), flip(segment34), flip(segment12) ); end
    if Y==32, currentSequence=horzcat(currentSequence, segment34      , segment12      , segment23       ); end
    if Y==33, currentSequence=horzcat(currentSequence, segment34      , segment12      , flip(segment23) ); end
    if Y==34, currentSequence=horzcat(currentSequence, segment34      , flip(segment12), segment23       ); end
    if Y==35, currentSequence=horzcat(currentSequence, segment34      , flip(segment12), flip(segment23) ); end
    if Y==36, currentSequence=horzcat(currentSequence, flip(segment34), segment12      , segment23       ); end
    if Y==37, currentSequence=horzcat(currentSequence, flip(segment34), segment12      , flip(segment23) ); end
    if Y==38, currentSequence=horzcat(currentSequence, flip(segment34), flip(segment12), segment23       ); end
    if Y==39, currentSequence=horzcat(currentSequence, flip(segment34), flip(segment12), flip(segment23) ); end
    if Y==40, currentSequence=horzcat(currentSequence, segment34      , segment23      , segment12       ); end
    if Y==41, currentSequence=horzcat(currentSequence, segment34      , segment23      , flip(segment12) ); end
    if Y==42, currentSequence=horzcat(currentSequence, segment34      , flip(segment23), segment12       ); end
    if Y==43, currentSequence=horzcat(currentSequence, segment34      , flip(segment23), flip(segment12) ); end
    if Y==44, currentSequence=horzcat(currentSequence, flip(segment34), segment23      , segment12       ); end
    if Y==45, currentSequence=horzcat(currentSequence, flip(segment34), segment23      , flip(segment12) ); end
    if Y==46, currentSequence=horzcat(currentSequence, flip(segment34), flip(segment23), segment12       ); end
    if Y==47, currentSequence=horzcat(currentSequence, flip(segment34), flip(segment23), flip(segment12) ); end
    currentSequence=horzcat(currentSequence,X(4)+1:last);
    currentCost=cost(currentSequence,blockConnections,distance);
    if currentCost<bestCost, bestSequence=currentSequence; bestCost=currentCost; end
end
end