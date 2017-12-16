function [finalCode] = translator(finalSequence,actualConnections,block,line,plungeRate,feedRate,height,neutral)
%{
Objective: Translate the sequence and connection data to construct the
    improved NC code.

Input:
    finalSequence = the final sequence to be used for the improved NC code
    actualConnections = the actual connection points to be used in the
        final sequence
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
    plungeRate = the speed in which the tool plunges into the material
    feedRate = the speed in which the tool moves above the material, cuts 
        through the material, or retracts from the material. 
    height = the level at which the tool hovers over the material during
        rapid movement
    neutral = the level to which the tool descends right before plunging
Output:
    finalCode = the final string of NC code to be printed on an NC file
%}
%% Check for Error
if ~isfield(block(1), 'globalListIndices') || ~isfield(block(1), 'connectionIndices'), error('Wrong block structure format'); end 
if ~isfield(line(1), 'X') || ~isfield(line(1), 'Y'), error('Wrong line structure format'); end 
%% Initilize Standard Lines (repetitive)
finalLines = [];
emptyLine.N=[];
emptyLine.M=[];
emptyLine.G=[];
emptyLine.X=[];
emptyLine.Y=[];
emptyLine.Z=[];
emptyLine.I=[];
emptyLine.J=[];
emptyLine.K=[];
emptyLine.F=[]; 
    %Ascend Lines:
rapidAscend = struct(emptyLine);
rapidAscend.G = 0;
rapidAscend.Z = height;
    %Descend Lines:    
rapidDescend = struct(emptyLine);
rapidDescend.G = 0;
rapidDescend.Z = neutral;
    %Rapid Traverse Lines: ([x y] to be added later]    
rapidTraverse = struct(emptyLine);
rapidTraverse.G = 0;
rapidTraverse.Z = height;
%% Rearrange Blocks to Fit Connection and Sequence Requirements
for i = 1:length(finalSequence)
    currentBlock = finalSequence(i);
    [~,nthConnectionIndex] = find(block(currentBlock).globalListIndices==actualConnections(i));
    firstLineOfBlock = block(currentBlock).connectionIndices(nthConnectionIndex);
        %Closed Contour
    if strcmp(block(currentBlock).curveType,'closed')
        blockLineOrder = (block(currentBlock).connectionIndices)+1; %the start of the block is the end of the block; shifting by one still includes every point
        if firstLineOfBlock==block(currentBlock).connectionIndices(1)
            blockLineOrder = vertcat(block(currentBlock).connectionIndices(1),blockLineOrder);
            blockLines = line(blockLineOrder);
        else
            while blockLineOrder(end)~=firstLineOfBlock   %the first line coordinates are also the last line coordinates of the block; maintain correct G values
                blockLineOrder = circshift(blockLineOrder,1,1); %circular shift across the first dimension (rows) by one move
            end
            blockLineOrder = vertcat(firstLineOfBlock,blockLineOrder);
            blockLines = line(blockLineOrder);
            blockLines(1).G = 1;       %first line of the block is a plunge
        end    
        %Open Contour            
    elseif strcmp(block(currentBlock).curveType,'open')
        if firstLineOfBlock==block(currentBlock).connectionIndices(1)
            blockLines = line(block(currentBlock).indices);
        else 
            blockLineOrder = flip(block(currentBlock).indices);  %new flipped order
            blockLines = line(flip(blockLineOrder));  %original order, so no I,J,K in first line
            temporary = line(blockLineOrder);         %new flipped order
            [blockLines(1:end).X] = temporary.X;
            [blockLines(1:end).Y] = temporary.Y;
            [blockLines(2:end).G] = flip(line([block(currentBlock).indices(2:end)]).G); %flipping the sequence necessitates that the end points pertaining to the operation is shifted so that the endpoint is correct
            [blockLines(2:end).I] = flip(line([block(currentBlock).indices(2:end)]).I); %include I, J, K in the flipping so they pair with the rotation operation
            [blockLines(2:end).J] = flip(line([block(currentBlock).indices(2:end)]).J);
            [blockLines(2:end).K] = flip(line([block(currentBlock).indices(2:end)]).K);
            n=0;
            while n<length(blockLines)
                n=n+1;
                if blockLines(n).G==2, blockLines(n).G=3; %reverse from all clockwise motion to counter-clockwise if open contour order is flipped 
                elseif blockLines(n).G==3, blockLines(n).G=2; %reverse from all counter-clockwise motion to clockwise if open contour order is flipped   
                end
            end
            blockLines(1).G = 1;       %first line of the block is a plunge
        end
        %Point  
    elseif strcmp(block(currentBlock).curveType,'point')
            blockLines = line(block(currentBlock).connectionIndices(1)); %points don't get shifted
    else error('Invalid block type'); 
    end
        %Fill Rapid Traverse [x y] coordinate
    rapidTraverse.X = blockLines(1).X;
    rapidTraverse.Y = blockLines(1).Y;
        %Fill All Feedrate Values in Block        
    for j = 1:length(blockLines), blockLines(j).F = feedRate; end
        %Replace First Feedrate with the Plungrate (the only instance this rate is used)        
    blockLines(1).F = plungeRate;
        %The First Block is a Special Case
    if i==1
        finalLines = vertcat(finalLines, blockLines);
    else
        %The Other Blocks Require Lines for Position Transfer            
        finalLines = vertcat(finalLines, rapidTraverse);
        finalLines = vertcat(finalLines, rapidDescend);
        finalLines = vertcat(finalLines, blockLines);
        finalLines = vertcat(finalLines, rapidAscend);
    end
end
%% Assemble the Optimized Code into a Single Structure   
firstLine = block(1).connectionIndices; 
initialLines = line(1:firstLine-1);             %all lines up to the start of the first block
finalLines = vertcat(initialLines,finalLines);  %append the main code lines
finalLines = vertcat(finalLines,line(end));     %append the ending line
%% Clean Up Code
for i = 1:length(finalLines)
    if finalLines(i).G==0, finalLines(i).F = []; end %all lines that use 'G0' do not have feedrate  
end
for i = 1:length(finalLines)
    finalLines(i).N = i-1; % fix line numberssince line number in block structure is offset by one (MATLAB starting index is 1, NC code starting number is 0)
end 
%% Finalize the Optimized Code into a String
finalCode = '';
for i = 1:length(finalLines)
    newLine = strcat('N', num2str(finalLines(i).N));
    if ~isempty(finalLines(i).M), newLine = strcat(newLine, 'M', num2str(finalLines(i).M)); end
    if ~isempty(finalLines(i).G), newLine = strcat(newLine, 'G', num2str(finalLines(i).G)); end
    if ~isempty(finalLines(i).X), newLine = strcat(newLine, 'X', num2str(finalLines(i).X)); end
    if ~isempty(finalLines(i).Y), newLine = strcat(newLine, 'Y', num2str(finalLines(i).Y)); end
    if ~isempty(finalLines(i).Z), newLine = strcat(newLine, 'Z', num2str(finalLines(i).Z)); end
    if ~isempty(finalLines(i).I), newLine = strcat(newLine, 'I', num2str(finalLines(i).I)); end
    if ~isempty(finalLines(i).J), newLine = strcat(newLine, 'J', num2str(finalLines(i).J)); end
    if ~isempty(finalLines(i).K), newLine = strcat(newLine, 'K', num2str(finalLines(i).K)); end
    if ~isempty(finalLines(i).F), newLine = strcat(newLine, 'F', num2str(finalLines(i).F)); end
    finalCode = strcat(finalCode, newLine, '\n');
end
end