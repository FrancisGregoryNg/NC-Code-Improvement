function [distance,globalConnectionList] = calculateDistances(block)
%{
Objective: Make a distance matrix by calculating the distances between each 
    of the block connection points; and make a global connection list with
    the proper [x y] values based on the global list indices.
 
Input:
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
    distance = the distance matrix for all connection points
    globalConnectionList = the [x y] values of the connection points,
        ordered according to the global list indices
%}
%% Initialize Arrays
distance=zeros(block(end).globalListIndices(end));
globalConnectionList=zeros(length(distance),2);
%% Global Connection List
q=0;
n=0;
while n<length(block)
    n=n+1;
    x=0;
    while x<length(block(n).globalListIndices)
        x=x+1;
        q=q+1;
        globalConnectionList(q,1:2)=block(n).connectionPoints(x,1:2);   %copy data from the block structure to the globalConnectionList to be used in the calculations for the distance matrix
    end
end
%% Distance Matrix
n=0;
while n<length(globalConnectionList)
    n=n+1;
    x=n;
    while x<length(globalConnectionList)
        x=x+1;
        distance(n,x)=sqrt((globalConnectionList(n,1)-globalConnectionList(x,1))^2+(globalConnectionList(n,2)-globalConnectionList(x,2))^2);    %use the linear distance formula based from the Pythagorean theorem
        distance(x,n)=distance(n,x);    %reflect the matrix along its main diagonal because distance is commutative and only the top-right half of the matrix has been populated
    end
end
end