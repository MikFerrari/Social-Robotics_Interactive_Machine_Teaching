function labels = label_prob_2_label(label_prob,labels)

    if label_prob >= 0.5
        labels = [labels; "Positive"];
    else
        labels = [labels; "Negative"];
    end

end
