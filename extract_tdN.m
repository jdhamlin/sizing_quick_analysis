%% Function to extract t and dN

function T = extract_tdN(cellData)
%EXTRACT_TDN Convert a 1xN cell array of structs with fields t and dN into a table
%
%   T = extract_tdN(cellData)
%   cellData : 1xN cell array, each cell containing a struct with fields:
%              - t  : datetime vector
%              - dN : numeric matrix (rows must match t length)
%   T        : table with datetime column 't' and numeric matrix column 'dN'


    numCols = cellfun(@(x) size(x.dN, 2), cellData);
    refCols = numCols(1);

    % resize smps_aps data for future analysis
    non_matching_idx = find(numCols ~= refCols);
    for i = non_matching_idx
        D_correct = cellData{1}.D;
        D_incorrect = cellData{i}.D;
        dN_incorrect = cellData{i}.dN;

       cellData{i}.D = interp1(D_incorrect, D_incorrect, D_correct, 'linear', 'extrap');
       numRows = size(dN_incorrect, 1);
       dN_corrected = nan(numRows, length(D_correct));

       for r = 1:numRows
            dN_corrected(r, :) = interp1(D_incorrect, dN_incorrect(r, :), D_correct, 'linear', 'extrap');
       end
       cellData{i}.dN = dN_corrected;

       % replace negative values with 0
       cellData{i}.dN(:,1:141) = 0;
       cellData{i}.dN(cellData{i}.dN < 0) = 0;
    end
    % Flatten cell array into struct array
    S = [cellData{:}];

    % Extract t and dN from each struct
    t_all  = {S.t};   % cell array of datetime vectors
    dN_all = {S.dN};  % cell array of double matrices

    % Check consistency
    len_t  = cellfun(@numel, t_all);
    len_dN = cellfun(@(x) size(x,1), dN_all);


    % remove extra t when length of t ~= length dN
    for k = 1:numel(t_all)
        if len_t(k) ~= len_dN(k)
            t_all{k} = t_all{k}(1:end-1);
        end
    end
    % Concatenate vertically
    t_combined  = vertcat(t_all{:});
    dN_combined = vertcat(dN_all{:});

    % Build table
    T = table(t_combined, dN_combined);

end