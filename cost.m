function [cost] = cost(sequence,blockConnections,block,distance,plungeRate,feedRate,height,neutral,depth)
%{
Objective: Get the cost of the current block sequence as the weighted sum
    of the block lengths and the distance between the block connections.
    The plunge is given a weight of the ratio between the feed rate and the
    plunge rate. This is because speed multiplied by time equals distance, 
    making time equal to distance over speed. Unity weight is given to the 
    other aspects such as the block length, the inter-block distance, the 
    tool retraction, and the pre-plunge descent. Afterwards, the cost is
    divided by the feed rate to get the final cost.
  
Input:
    sequence = the sequence of blocks
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
    cost = the cost of the current block sequence
%}
%% Calculate Cost
n=0;
cost=0;
while n<length(sequence)-1
    n=n+1;
    %cost=cost+(neutral-depth)*feedRate/plungeRate; %plunge
    %cost=cost+(height-depth); %retract
    %cost=cost+block(sequence(n)).length; %cut through block
    cost=cost+distance(blockConnections.from(sequence(n),sequence(n+1)),blockConnections.to(sequence(n),sequence(n+1))); %move to next block
    cost=cost/feedRate;
end
%% Include the Path Back to Initial Point
    n=n+1;
    %cost=cost+(neutral-depth)*feedRate/plungeRate; %plunge
    %cost=cost+(height-depth); %retract
    %cost=cost+block(sequence(n)).length; %cut through block
    cost=cost+distance(blockConnections.from(sequence(n),sequence(1)),blockConnections.to(sequence(n),sequence(1))); %move to next block
    cost=cost/feedRate;
end