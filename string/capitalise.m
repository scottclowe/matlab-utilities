%CAPITALISE Capitalise a string.

function str = capitalise(str)

if length(str)==1
    str = upper(str);
else
    str = [upper(str(1)),str(2:end)];
end

end
