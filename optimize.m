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
function [finalSequence] = optimize(blockConnections,block,distance)
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
    distance = the distance matrix
Output:
    finalSequence = the final sequence to be used for the improved NC code
%}
%% Initialize Arrays
bestSequence=1:length(block);
bestCost=cost(bestSequence(:),blockConnections,distance);
fprintf('Initial Cost: %.4f\n', bestCost);
maxPartitions=floor(length(block)/7);
partitions=1;
%% Retries Using Initial Sequence
sets=5;
i=0;
while i<sets
    i=i+1;
%% Repeat Sets
    n=0;
    while n<maxPartitions
        n=n+1;
        if n~=1, partitions=partitions-((-1)^i); end            %number of partitions varies as the current set number progresses; each trial alternately reverses the partition increase/decrease (initially increases)
        lengthOfPartition=floor(length(block)/partitions);      %does not include the last partition, which is longer than the rest
        p=0;
        previousEnd=0;
%% Perfom Opt Operations in Partitions
        while p<partitions
            p=p+1;
            A=previousEnd+1;
            if p==partitions, B=length(block); else B=previousEnd+lengthOfPartition; previousEnd=B; end  %complete the sequence when at the final partition
            repeat2opt=ceil(50*(length(block)/partitions));    %more manipulations when there are more elements in the partition
            x=0;
            while x<repeat2opt
                x=x+1;
                currentSequence=bestSequence;
                [currentSequence(A:B)]=perform2opt(bestSequence(A:B),blockConnections,distance);
                currentCost=cost(currentSequence(:),blockConnections,distance);
                bestCost=cost(bestSequence(:),blockConnections,distance);
                if currentCost<bestCost, bestSequence=currentSequence; end
                if mod(x,5)==0 
                    currentSequence=bestSequence;
                    [currentSequence(A:B)]=perform3opt(bestSequence(A:B),blockConnections,distance); 
                    currentCost=cost(currentSequence(:),blockConnections,distance);
                    bestCost=cost(bestSequence(:),blockConnections,distance);
                    if currentCost<bestCost, bestSequence=currentSequence; end
                end
                if mod(x,20)==0
                    currentSequence=bestSequence;
                    [currentSequence(A:B)]=perform4opt(bestSequence(A:B),blockConnections,distance); 
                    currentCost=cost(currentSequence(:),blockConnections,distance);
                    bestCost=cost(bestSequence(:),blockConnections,distance);
                    if currentCost<bestCost, bestSequence=currentSequence; end
                end
            end
        end
        fprintf('Set = %d out of %d, Partitions = %d, 2-Opt Moves = %d, 3-Opt Moves = %d, 4-Opt Moves = %d, Cost = %.10f\n',i,sets,partitions,repeat2opt,floor(repeat2opt/5),floor(repeat2opt/20),bestCost);   
    end
end
finalSequence=bestSequence;
end