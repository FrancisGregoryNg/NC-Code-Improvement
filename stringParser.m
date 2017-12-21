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
function [values, labels] = stringParser(code)
%{
Objective: Split a line of code into labels and their corresponding values.
  
Input: 
    code = single line of code from the code array
Output:  
    values = the numerical values from the code corresponding to the letter
        addresses
    labels = the letter addresses
%}
%% Specify the Delimiter Alphabet for Splitting
alphabet = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z', ';'];
%% Parse the String and Split Into Labels and Corresponding Values
%[values,labels] = strsplit(code, alphabet);
%values(1) = []; %initial value is blank since labels are paired to the values that come after, not before

%returns an array which is the same size as 'code' but has '1' if element of code exists in 'alphabet'
%otherwise 0
elements = ismember(code, alphabet);

labelsChar = code(elements);

labels = cell(1, length(labelsChar));
for i = 1:length(labelsChar)
    labels{i} = labelsChar(i);
end

indices = find(elements);
indices = [indices length(code)+1];
values = cell(1,length(labels));
for i = 1:length(labels)
    word = [];
    for j = indices(i)+1:(indices(i+1)-1)
        word = [word code(j)];
    end
    values(i) = {word};
end

end