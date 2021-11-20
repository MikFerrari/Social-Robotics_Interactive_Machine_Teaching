function labels = label_prob_2_label(label_prob,labels,probability_flag)
    
    switch probability_flag

        case "Deterministic"
            if label_prob >= 0.5
                labels = [labels; "Positive"];
            else
                labels = [labels; "Negative"];
            end

        case "Probabilistic"
            1 == 1;
    end

    

end
