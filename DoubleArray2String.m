function str = DoubleArray2String(x)
    str_cell=cell(1,length(x));
    for i=1:length(x)
        n = x(i);
        l = fix(n);
        r = n-l;
        str_cell{i} = strjoin({Double2String(l),Reminder2String(r)},'.');
    end
    str = strjoin(str_cell,',');
end

function str = Double2String(n)
    str = '';
    isNegative = false;
    if n < 0
        n = -n;
        isNegative = true;
    end
    while n > 0
        d = mod(n,10);
        str = [char(48+d), str];
        n = (n-d)/10;
    end
    if isempty(str)
        str='0' ;
    end
    
    if isNegative
       str = ['-' str]; 
    end
end

function str = Reminder2String(n)
    str = '';
    if n < 0
        n = -n;
        isNegative = true;
    end
    while (n > 0) && (n < 1)
        n = n*10;
        d = fix(n);
        str = [str char(48+d)];
        n = n-d;
    end
    if isempty(str)
        str='0' ;
    end
end