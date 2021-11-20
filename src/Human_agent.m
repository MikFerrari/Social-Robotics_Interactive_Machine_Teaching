classdef Human_agent
    %HUMAN_AGENT Class that mimics the human teacher
    
    properties
        optimality % Optimal, Seed, Naive, Manual
        deterministic % True or False
        true_threshold
        distr_mu
        distr_sigma

        count_positive = 0;
        count_negative = 0;

        decrement = 0.1;
        reverse_thresh = 0.8;
    end
    

    methods

        function obj = Human_agent(optim,det,true_thresh,mu,sigma)
            %HUMAN_AGENT Construct an instance of this class
            obj.optimality = optim;
            obj.deterministic = det;
            obj.true_threshold = true_thresh;
            obj.distr_mu = mu;
            obj.distr_sigma = sigma;
        end


        function label_prob = response_exact(obj,input)
            %   label_prob = P(label == 'Positive')
            if obj.deterministic == true % deterministic labels  
                if input > obj.true_threshold
                    label_prob = 1;
                else
                    label_prob = 0;
                end
            else % stochastic labels
                if input > obj.true_threshold
                    label_prob = normrnd(obj.distr_mu,obj.distr_sigma);
                else
                    label_prob = normrnd(1-obj.distr_mu,1-obj.distr_sigma);
                end         
            end
        end


        function label_prob = response_imperfect(obj,input)
            %   label_prob = P(label == 'Positive')
            label_prob = obj.response_exact(input);
            reverse_prob = random('Uniform',0,1);
            
            if reverse_prob > obj.reverse_thresh
                label_prob = 1-label_prob;
            end
        end


        function label_prob = response_manual(obj)
            answer = questdlg('To which class does the current sample belong?', ...
                            'Sample Labelization', ...
                            'Positive','Negative','Positive');

            if obj.deterministic == true
                % Handle response
                switch answer
                    case 'Positive'
                        disp([answer ' The sample belongs to the POSITIVE class'])
                        label_prob = 1;
                    case 'Negative'
                        disp([answer ' The sample belongs to the NEGATIVE class'])
                        label_prob = 0;
                end

            else
                input_ok = false;
                w = [];
                while input_ok == false
                    answer_prob = inputdlg('How much do you trust your labelization? [0 = not at all, 1 = completely]', ...
	                                    'Sample Labelization - Probability');
                    delete(w)
                    if answer_prob <= 1 && answer_prob >= 0 && isfloat(answer_prob)
                        input_ok = true;
                    else
                        w = warndlg('Probability must be between 0 and 1!');
                    end
                end
                % Handle response
                switch answer
                    case 'Positive'
                        disp([answer " The sample belongs to the POSITIVE class with probability " string(answer_prob*100) " %"])
                        label_prob = answer_prob;
                    case 'Negative'
                        disp([answer " The sample belongs to the NEGATIVE class with probability " string(answer_prob*100) " %"])
                        label_prob = 1-answer_prob;
                end

            end
        end


        function input_sample = provide_input_optimal(obj,lo_bound,hi_bound,delta,prev_sample)
            if prev_sample > obj.true_threshold
                input_sample = max([lo_bound obj.true_threshold-delta]);
            elseif prev_sample < obj.true_threshold
                input_sample = min([hi_bound obj.true_threshold+delta]);
            else
                input_sample = obj.true_threshold;
            end  
        end


        function [input_sample,obj] = provide_input_seed(obj,lo_bound,hi_bound,delta)
            if obj.count_positive == 0
                input_sample = min([hi_bound obj.true_threshold+delta]);
                obj.count_positive = 1;
            elseif obj.count_negative == 0
                input_sample = max([lo_bound obj.true_threshold-delta]);
                obj.count_negative = 1;
            else
                input_sample = random('Uniform',lo_bound,hi_bound);
            end
        end

        function input_sample = provide_input_naive(~,lo_bound,hi_bound)
            input_sample = random('Uniform',lo_bound,hi_bound);
        end


        function input_sample = provide_input_manual(~,lo_bound,hi_bound)
            input_ok = false;
            w = [];
            while input_ok == false
                prompt = strcat(sprintf("Type the value for the next input you want to provide to the computer.\n"), ...
                                "Type a value between ", string(lo_bound), " and ", string(hi_bound),":");
                input_sample = inputdlg(prompt,'Sample Input');
                delete(w)
                if isempty(input_sample)
                    break
                end
                input_sample = str2double(input_sample{1});
                if input_sample >= lo_bound && input_sample <= hi_bound
                    input_ok = true;
                else
                    w = warndlg('Input out of range!');
                end
            end
        end


        function [in,obj] = teacher_input(obj,lo_bound,hi_bound,delta,prev_sample)
            switch obj.optimality
                case "Optimal"
                    in = provide_input_optimal(obj,lo_bound,hi_bound,delta,prev_sample);
                case "Seed"
                    [in,obj] = provide_input_seed(obj,lo_bound,hi_bound,delta);
                case "Naive"
                    in = provide_input_naive(obj,lo_bound,hi_bound);
                case "Manual"
                    in = provide_input_manual(obj,lo_bound,hi_bound);
            end
        end

    end

end
