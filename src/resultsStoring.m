metrics.labels = labels;
metrics.iters = iters;
metrics.inputs = inputs;
metrics.label_probabilities = label_probs;
metrics.thresholds = thresholds;
metrics.iter_errors = iter_errors;

save(strcat('.\results\','humanInit',response_flag,'_',optimality_flag,'_',probability_flag,'.mat'),'metrics')