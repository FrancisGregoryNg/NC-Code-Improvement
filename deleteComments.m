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
function [codeArray] = deleteComments(codeArray)
%{
Objective: Delete the comments from the code array to make it manageable
    for subsequent operations on the code. 
  
Input: 
    codeArray = cell array of strings that each contains lines of code
Output:     
    codeArray = codeArray without the comments
%}
%% Delete Comments
n=1;
while n<=length(codeArray)
    x=1;
    while x<=length(codeArray{n})
      if codeArray{n}(x)==';', codeArray{n}(x:length(codeArray{n}))='';end %the semicolon signifies that the rest of the line are just comments
      x=x+1;
    end
    n=n+1;
end
end