function [bestSequences,trials] = optimize(trials,sets,repeat2opt,repeat3opt,repeat4opt,blockConnections,block,distance,plungeRate,feedRate,height,neutral,depth)
%{
Objective: Perform the 2-opt, 3-opt, and 4-opt algorithms on the block
    sequence to arrive at an improved sequence with a minimized cost,
    though not assured to be optimal. Multiple trials are done with
    multiple sets of the 2-opt, 3-opt, and 4-opt algorithms performed
    repeatedly in each set. The best results of each trial are recorded to
    be used for rectification.
    Note: The recommended values for trials, sets, repeat2opt, repeat3opt,
        and repeat4opt are [10,10,25,10,5]. These have been determined to
        be effective by simple trial-and-error, so improvements are quite
        possible.

Input:
    trials = the number of trials where the sequence with the best cost is
        determined from a random starting sequence
    sets = the number of sets within each trial where the 2-opt, 3-opt, and
        4-opt moves will be performed
    repeat2opt = the number of 2-opt moves in a set
    repeat3opt = the number of 3-opt moves in a set
    repeat4opt = the number of 4-opt moves in a set
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
    bestSequences = the array of best sequences which are candidates for
        the final sequence after rectification to meet connection
        requirements for open contours and closed contours (i.e. open
        contours must be connected through its two ends, closed contours
        must be connected only at one point).
%}
%Should make the opt operations in segments of the code to make it more manageable
%Test
%% Initialize Arrays
bestCosts=zeros(trials,1);
bestSequences=ones(trials,length(block));    %Ones are used because 1 will be fixed as the initial point of all sequences.
%% Retries Using Initial Sequence
i=0;
while i<trials
    i=i+1;
    %if i==1
    A=([1:length(block)]); %else A=randperm(length(block)); end
    bestSequences(i,2:end)=A(A~=1);  %The use of Ones in initializing the array makes it possible to just specify the other values so that 1 will be the intial point in the sequence.
    bestCosts(i)=cost(bestSequences(i,:),blockConnections,block,distance,plungeRate,feedRate,height,neutral,depth);
    fprintf('Initial Cost: %.4f\n', bestCosts(i));
%% Repeat Sets
    n=0;
    while n<sets
        n=n+1;
        fprintf('Trial = %d out of %d, Set = %d out of %d, Cost = %.10f\n',i,trials,n,sets,bestCosts(i));
%% 2-Opt
        x=0;
        while x<repeat2opt
            x=x+1;
            %fprintf('\t2-Opt = %d out of %d... ',x,repeat2opt);
            [currentSequence,currentCost]=perform2opt(bestSequences(i,:),bestCosts(i),blockConnections,block,distance,plungeRate,feedRate,height,neutral,depth);
            if currentCost<bestCosts(i), bestSequences(i,:)=currentSequence; bestCosts(i)=currentCost; end
            %fprintf('done.  \t Current Cost: %.10f\n',currentCost);
        end
%% 3-Opt
        x=0;
        while x<repeat3opt
            x=x+1;
            %fprintf('\t3-Opt = %d out of %d... ',x,repeat3opt);
            [currentSequence,currentCost]=perform3opt(bestSequences(i,:),bestCosts(i),blockConnections,block,distance,plungeRate,feedRate,height,neutral,depth);
            if currentCost<bestCosts(i), bestSequences(i,:)=currentSequence; bestCosts(i)=currentCost; end
            %fprintf('done.  \t Current Cost: %.10f\n',currentCost);
        end
%% 4-Opt
        x=0;
        while x<repeat4opt
            x=x+1;
            %fprintf('\t4-Opt = %d out of %d... ',x,repeat4opt);
            [currentSequence,currentCost]=perform4opt(bestSequences(i,:),bestCosts(i),blockConnections,block,distance,plungeRate,feedRate,height,neutral,depth);
            if currentCost<bestCosts(i), bestSequences(i,:)=currentSequence; bestCosts(i)=currentCost; end
            %fprintf('done.  \t Current Cost: %.10f\n',currentCost);
        end
        if bestCosts(i)>1.2*min(bestCosts), A=randperm(length(block)); bestSequences(i,2:end)=A(A~=1); end %Disregard the bad initial values which make it difficult for the algorithm to improve the sequence.
    end
end
%% Display Trial Solutions
i=0;
while i<trials
    i=i+1;
    fprintf('Best Sequence Trial# %d:  \t',i);
    n=0;
    while n<length(block)
        n=n+1;
        fprintf('%d ',bestSequences(i,n));
    end
	fprintf('\tCost: %.10f\n',bestCosts(i));
end
end
