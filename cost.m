function [cost] = cost(sequence,blockConnections,distance)
%{
Objective: Get the cost of the current block sequence based on the distance 
    between the block connections. The connection back to the initial point
    is not included so as to accommodate partitioned opt moves.
  
Input:
    sequence = the sequence of blocks
    blockConnections = the globalConnectionList indices of the closest
        connection points between two blocks
    distance = the distance matrix
Output:
    cost = the cost of the current block sequence
%}
%% Calculate Cost (path back to initial point is not included)
n=0;
cost=0;
while n<length(sequence)-1
    n=n+1;
    %cost=cost+(neutral-depth)*feedRate/plungeRate; %plunge
    %cost=cost+(height-depth); %retract
    %cost=cost+block(sequence(n)).length; %cut through block
    cost=cost+distance(blockConnections.from(sequence(n),sequence(n+1)),blockConnections.to(sequence(n),sequence(n+1))); %move to next block
    %cost=cost/feedRate;
end
end