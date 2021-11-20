function input_sample = provide_input_computer(prev_inputs,prev_labels,lo_bound,hi_bound)
    % INPUT_SAMPLE First step of Active Learning: select a new input, based on previous inputs and labels
    
    if numel(prev_inputs) == 0
        input_sample = random('Uniform',0,1);
    
    else
        idx_pos = contains(prev_labels,"Positive");
        idx_neg = contains(prev_labels,"Negative");
        
        if numel(find(idx_pos)) == 0 % All labels are 'Negative'
            max_neg = max(prev_inputs(idx_neg));
            input_sample = (max_neg+hi_bound)/2;
        elseif numel(find(idx_neg)) == 0 % All labels are 'Positive'
            min_pos = min(prev_inputs(idx_pos));
            input_sample = (min_pos+lo_bound)/2;
        else
            min_pos = min(prev_inputs(idx_pos));
            max_neg = max(prev_inputs(idx_neg));
            input_sample = (min_pos+max_neg)/2;
        end

    end

end