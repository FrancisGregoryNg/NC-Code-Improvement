function [line] = segregateLines(codeArray)
%{
Objective: Structure the data from the lines of code based on the pertinent
    letter addresses.
  
Input:     
    codeArray = cell array of strings that each contains lines of code
Output:    
    line = the structured line data
        where:
            line.N = line number
            line.M = M-code, for starting and ending the program, among
                other purposes
            line.G = G-code, for the type of tool movement
            line.X = X-coordinate of destination, absolute coordinates
            line.Y = Y-coordinate of destination, absolute coordinates
            line.Z = Z-coordinate of destination, absolute coordinates
            line.I = X-coordinate of circular center, absolute coordinates
            line.J = Y-coordinate of circular center, absolute coordinates
            line.K = Z-coordinate of circular center, absolute coordinates
            line.F = feed rate     
%}
%% Initialize Line Structure
sample.N=[];
sample.M=[];
sample.G=[];
sample.X=[];
sample.Y=[];
sample.Z=[];
sample.I=[];
sample.J=[];
sample.K=[];
sample.F=[];
line=repmat(sample,length(codeArray),1);
%% Populate Line Structure
n=1;
while n<=length(codeArray)     
    [values,labels]=stringParser(codeArray{n});
    x=1;
    while x<=length(labels)
        if labels{x}=='N', line(n).N=str2double(values{x}); end
        if labels{x}=='M', line(n).M=str2double(values{x}); end
        if labels{x}=='G', line(n).G=str2double(values{x}); end
        if labels{x}=='X', line(n).X=str2double(values{x}); end
        if labels{x}=='Y', line(n).Y=str2double(values{x}); end
        if labels{x}=='Z', line(n).Z=str2double(values{x}); end
        if labels{x}=='I', line(n).I=str2double(values{x}); end
        if labels{x}=='J', line(n).J=str2double(values{x}); end
        if labels{x}=='K', line(n).K=str2double(values{x}); end
        if labels{x}=='F', line(n).F=str2double(values{x}); end
        x=x+1;
    end
    n=n+1;
end
end