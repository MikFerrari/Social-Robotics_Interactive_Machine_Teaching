function [thresh,iter_error,min_pos,max_neg] = test_convergence(labels,true_threshold)
    
    idx_pos = contains(labels,"Positive");
    idx_neg = contains(labels,"Negative");
    min_pos = min(inputs(idx_pos));
    max_neg = max(inputs(idx_neg));

    if ~isempty(find(idx_pos)) && ~isempty(find(idx_neg)) %#ok<EFIND> 
        thresh = (min_pos+max_neg)/2;
        iter_error = abs(thresh-true_threshold);
    end

end

