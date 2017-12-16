function [distance] = cleanDistanceMatrix(distance,block)
%{
Objective: Eliminate distance values for connections within the same block.  

Input:
    distance = the distance matrix
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
     distance = the cleaned distance matrix
%}
%% Clean Distance Matrix
n=0;
while n<length(block)
    n=n+1;
    x=0;
    while x<length(block(n).globalListIndices)
        x=x+1;
        q=x-1;
        while q<length(block(n).globalListIndices)  
            q=q+1;
            distance(block(n).globalListIndices(x),block(n).globalListIndices(q))=inf;  
            distance(block(n).globalListIndices(q),block(n).globalListIndices(x))=inf;
        end
    end
end
end