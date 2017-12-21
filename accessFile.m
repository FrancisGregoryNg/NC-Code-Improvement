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
function [codeArray] = accessFile(file)
%{
Objective: Import the data from the NC file.

Input:      
    file = filename of the NC file, including the filetype (.nc)
Output:     
    codeArray = cell array of strings that each contains lines of code
%}
%% Import Data
%codeArray = importdata(file);

fileID = fopen(file);

rawCode = fread(fileID);

numOfLines = 0;
for i = 1:length(rawCode)
    if rawCode(i) == 10
        numOfLines = numOfLines + 1;
    end
end

codeChars = char(numOfLines);

rowNumber = 1;
colNumber = 1;
for i = 1:length(rawCode)
    if rawCode(i) == 13
        colNumber = 1;
    elseif rawCode(i) == 10
        rowNumber = rowNumber + 1;
    else
        codeChars(rowNumber, colNumber) = cast(rawCode(i), 'char');
        colNumber = colNumber + 1;
    end
end

codeArray = cell(size(codeChars, 1), 1);
for i = 1:size(codeChars, 1)
    codeArray{i} = codeChars(i, :);
end
%{
tline = fgets(fileID);
codeArray = [];
while ischar(tline)
    codeArray = [codeArray; cellstr(tline)];
    tline = fgets(fileID);
end
%}
end