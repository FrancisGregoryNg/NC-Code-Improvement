clear;
clc;
close;
[codeArray] = accessFile('test.nc');
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
file = fopen('improved.nc', 'w');
fprintf(file, finalCode);
fclose('all');