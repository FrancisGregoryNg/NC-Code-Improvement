function [codeArray] = accessFile(file)
%{
Objective: Import the data from the NC file.

Input:      
    file = filename of the NC file, including the filetype (.nc)
Output:     
    codeArray = cell array of strings that each contains lines of code
%}
%% Import Data
codeArray = importdata(file);
end