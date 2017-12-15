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
alphabet = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z', ';'};
%% Parse the String and Split Into Labels and Corresponding Values
[values,labels] = strsplit(code, alphabet);
values(1) = []; %initial value is blank since labels are paired to the values that come after, not before
end