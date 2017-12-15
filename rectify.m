function [finalSequence,finalCost,actualConnections] = rectify(trials,bestSequences,blockConnections,block,distance,plungeRate,feedRate,height,neutral,depth)
%{
Objective: Rectify the best sequences to utilize actual connection points 
    and then determine the final sequence.

Input:
    trials = the number of trials where the sequence with the best cost is  
        determined from a random starting sequence 
    bestSequences = the array of best sequences which are candidates for
        the final sequence after rectification to meet connection 
        requirements for open contours and closed contours (i.e. open
        contours must be connected through its two ends, closed contours
        must be connected only at one point).
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
    finalSequence = the final sequence to be used for the improved NC code
    finalCost = the cost of the final sequence
    actualConnections = the actual connection points to be used in the
        final sequence; the points where the previous block will connect to
        the current block
%}
%% Initialize
connectionLength = zeros(length(trials),1);
connections = zeros(length(trials),length(block));
%% Rectify
n=0;
while n<trials
    n=n+1;
    connectionLength(n)=0;
    x=0;
    while x<length(bestSequences(n,:))
        x=x+1;
        if x==1, t=bestSequences(n,length(block)); else t=bestSequences(n,x-1); end
        u=bestSequences(n,x);
        if x==length(block), v=bestSequences(n,1); else v=bestSequences(n,x+1); end
        if isequal(block(u).curveType,'point') 
            connections(n,x)=block(u).globalListIndices; 
            option1=distance(blockConnections.from(t,u),connections(n,x))+distance(connections(n,x),blockConnections.to(u,v));
            connectionLength(n)=connectionLength(n)+option1;
        end
        if isequal(block(u).curveType,'closed')
            option1=distance(blockConnections.from(t,u),blockConnections.to(t,u))+distance(blockConnections.to(t,u),blockConnections.to(u,v));      %length when both blocks connect to the closest connection point with the previous block
            option2=distance(blockConnections.from(t,u),blockConnections.from(u,v))+distance(blockConnections.from(u,v),blockConnections.to(u,v));  %length when both blocks connect to the closest connection point with the next block
            if option1<option2, connections(n,x)=blockConnections.to(t,u); connectionLength(n)=connectionLength(n)+option1; else connections(n,x)=blockConnections.from(u,v); connectionLength(n)=connectionLength(n)+option2; end
        end
        if isequal(block(u).curveType,'open')
            option1=distance(blockConnections.from(t,u),block(u).globalListIndices(1))+distance(block(u).globalListIndices(2),blockConnections.to(u,v));  %length when previous block connects to first connection point, and the next block connects to the second connection point
            option2=distance(blockConnections.from(t,u),block(u).globalListIndices(2))+distance(block(u).globalListIndices(1),blockConnections.to(u,v));  %length when next block connects to first connection point, and the previous block connects to the second connection point
            if option1<option2, connections(n,x)=block(u).globalListIndices(1); connectionLength(n)=connectionLength(n)+option1; else connections(n,x)=block(u).globalListIndices(2); connectionLength(n)=connectionLength(n)+option2; end
        end 
    end 
end
%% Finalize Output
[finalCost,chosen]=min(connectionLength);
finalCost=finalCost+2*(neutral-depth)*feedRate/plungeRate;  %plunges
finalCost=finalCost+2*(height-depth);                       %retractions
finalCost=finalCost+sum([block.length]);                    %cut through blocks
finalCost=finalCost/feedRate;
finalSequence=bestSequences(chosen,:);
actualConnections=connections(chosen,:);
%% Display Output
fprintf('Best Rectified Sequence:  \t');
n=0;
while n<length(block)
    n=n+1;
    fprintf('%d ',finalSequence(n));
end
fprintf('\tCost: %.10f\n',finalCost);
end