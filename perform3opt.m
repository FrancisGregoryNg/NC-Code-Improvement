function [bestSequence] = perform3opt(initialSequence,blockConnections,distance)
%{
Objective: Find three random numbers in the sequence. These will split the
    sequence into three segments. Consider A, B, and C as the random
    numbers in ascending order. The first segment is the combination of the 
    values from the starting point (1) up to A, and the values from C+1 up 
    to the end point. The remaining segments are [A+1 to B] and [B+1 to C].
    These two segments can be rearranged in 8 ways relative to the fixed
    segment. All these possible ways, except for the one which results in 
    the same sequence as the original, are assessed through the resulting
    cost and the altered sequence will be accepted if it improves the cost.
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
if length(initialSequence)<(2*3), return; end
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
X=sort([initialSequence(A),initialSequence(B),initialSequence(C)]);
%% Segment Manipulation
segment12=X(1)+1:X(2);
segment23=X(2)+1:X(3);
last=length(initialSequence);
Y=0;
while Y<7;
    Y=Y+1;
    currentSequence=1:X(1);    
    if Y==0, currentSequence=horzcat(currentSequence, segment12      , segment23       ); end %purposely ignore because it is just the same with the initial sequence
    if Y==1, currentSequence=horzcat(currentSequence, segment12      , flip(segment23) ); end
    if Y==2, currentSequence=horzcat(currentSequence, flip(segment12), segment23       ); end
    if Y==3, currentSequence=horzcat(currentSequence, flip(segment12), flip(segment23) ); end
    if Y==4, currentSequence=horzcat(currentSequence, segment23      , segment12       ); end
    if Y==5, currentSequence=horzcat(currentSequence, segment23      , flip(segment12) ); end
    if Y==6, currentSequence=horzcat(currentSequence, flip(segment23), segment12       ); end
    if Y==7, currentSequence=horzcat(currentSequence, flip(segment23), flip(segment12) ); end
    currentSequence=horzcat(currentSequence,X(3)+1:last);
    currentCost=cost(currentSequence,blockConnections,distance);
    if currentCost<bestCost, bestSequence=currentSequence; bestCost=currentCost; end
end
end