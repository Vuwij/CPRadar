function [func] = remove_zero_crossings(func)
    func = abs(func);
    for i=1:length(func)-1
        a1 = (func(i+1) - func(i)) + func(i+1) > 0;
        a2 = (func(i+1) > 0);

        if a1 ~= a2
            func(i+1:end) = -func(i+1:end);
        end
    end

