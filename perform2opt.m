function [bestSequence] = perform2opt(initialSequence,blockConnections,distance)
%{
Objective: Find two random numbers in the sequence. These will split the
    sequence into two segments. Consider A as the smaller random number and 
    B as the larger. The first segment is the combination of the values 
    from the starting point (1) up to A, and the values from B+1 up to the 
    end point. The remaining segment composed of values from A+1 to B. The
    only alteration that could be done is to flip this segment. If the
    resulting cost improved, then accept the new sequence.
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
Output: 
    bestSequence = the improved sequence of blocks
    bestCost = the cost of the improved block sequence
%}
%% Initialize the Output
bestSequence=initialSequence;
bestCost=cost(initialSequence,blockConnections,distance);
%% Starting Criterion
if length(initialSequence)<(2*2), return; end
%% Dislocation Points
while (1)
    A=randi(length(initialSequence));
    if A<length(initialSequence), break; end 
end
while (1)
    B=randi(length(initialSequence));
    if B>A, break; end 
end
%% Segment Manipulation
currentSequence=horzcat(initialSequence(1:A),initialSequence(flip(A+1:B)),initialSequence(B+1:end));
currentCost=cost(currentSequence,blockConnections,distance);
if currentCost<bestCost, bestSequence=currentSequence; end
end