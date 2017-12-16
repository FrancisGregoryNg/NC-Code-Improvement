function [bestSequence] = optimize(blockConnections,block)
%{
Objective: Perform the 2-opt, 3-opt, and 4-opt algorithms on the block
    sequence to arrive at an improved sequence with a minimized cost,
    though not assured to be optimal.

Input:
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
Output:
    bestSequences = the array of best sequences which are candidates for
        the final sequence after rectification to meet connection
        requirements for open contours and closed contours (i.e. open
        contours must be connected through its two ends, closed contours
        must be connected only at one point).
%}
%% Initialize Arrays
bestSequence=1:length(block);
bestCost=cost(bestSequence(:),blockConnections,block,distance,plungeRate,feedRate,height,neutral,depth);
fprintf('Initial Cost: %.4f\n', bestCost);
maxPartitions=length(block)/7;
%% Retries Using Initial Sequence
trials=10;
i=0;
while i<trials
    i=i+1;
%% Repeat Sets
    sets=maxPartitions;
    partitions=0;
    n=0;
    while n<sets
        n=n+1;
        fprintf('Trial = %d out of %d, Set = %d out of %d, Cost = %.10f\n',i,trials,n,sets,bestCost);
        partitions=partitions-n*(-1^i);                                  %number of partitions varies as the current set number progresses; each trial alternately reverses the partition increase/decrease (initially increases)
        lengthOfPartition=floor(length(block)/partitions);      %does not include the last partition, which is longer than the rest
        p=0;
        previousEnd=0;
%% Perfom Opt Operations in Partitions
        while p<partitions
            p=p+1;
            A=previousEnd+1;
            if p==partitions, B=length(block); else B=previousEnd+lengthOfPartition; previousEnd=B; end  %complete the sequence when at the final partition
            repeat2opt=ceil(100*(length(block)/partitions));    %more manipulations when there are more elements in the partition
            x=0;
            while x<repeat2opt
                x=x+1;
                fprintf('\t2-Opt = %d out of %d... ',x,repeat2opt);
                [bestSequence(A:B),~]=perform2opt(bestSequence(A:B),bestCost,blockConnections,block,distance,plungeRate,feedRate,height,neutral,depth);
                fprintf('done.  \t Current Cost: %.10f\n',currentCost);
                if mod(x,5)==0 
                    fprintf('Performing 3-opt... ');
                    [bestSequence(A:B),~]=perform3opt(bestSequence(A:B),bestCost,blockConnections,block,distance,plungeRate,feedRate,height,neutral,depth); 
                    fprintf('done.  \t Current Cost: %.10f\n',currentCost);
                end
                if mod(x,20)==0
                    fprintf('Performing 4-opt... ');
                    [bestSequence(A:B),~]=perform4opt(bestSequence(A:B),bestCost,blockConnections,block,distance,plungeRate,feedRate,height,neutral,depth); 
                    fprintf('done.  \t Current Cost: %.10f\n',currentCost);
                end
            end
        end
    end
end
end