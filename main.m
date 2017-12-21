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
function [] = main(varargin)
if nargin < 2
    error('Not enough input arguments!');
end

inputFile = varargin{1};
outputFile = varargin{2};

[codeArray] = accessFile(inputFile);
[codeArray] = deleteComments(codeArray);
[line] = segregateLines(codeArray);
[Z,height,neutral,depth] = getZValues(line);
[plungeRate,feedRate] = getFValues(line);
[line] = completeLines(line);
[block] = generateBlocks(line,height,depth);
[distance,globalConnectionList] = calculateDistances(block);
[distance] = cleanDistanceMatrix(distance,block);
[blockConnections] = blockDistance(block,distance);
[finalSequence] = optimize(blockConnections,block,distance);
[actualConnections] = rectify(finalSequence,blockConnections,block,distance);
[finalCode] = translator(finalSequence,actualConnections,block,line,plungeRate,feedRate,height,neutral);
file = fopen(outputFile, 'w');
fprintf(file, finalCode);
fclose('all');

end