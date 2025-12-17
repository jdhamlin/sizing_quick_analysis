%%% Remove unneeded fields from cell array
function T = removefields(cellData)
    S = cellData;
    S_cleaned = rmfield(cellData, setdiff(fieldnames(cellData), {'t', 'D', 'dN'}));
    T = S_cleaned;
end