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