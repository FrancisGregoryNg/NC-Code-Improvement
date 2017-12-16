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