classdef Human_agent
    %HUMAN_AGENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        deterministic % True or False
        true_threshold
        distr_mu
        distr_sigma
        seed_prob
        seed_lower_bound
        decrement = 0.1;
    end
    

    methods

        function obj = Human_agent(det,true_thresh,mu,sigma,seed_probability)
            %HUMAN_AGENT Construct an instance of this class
            %   Detailed explanation goes here
            obj.deterministic = det;
            obj.true_threshold = true_thresh;
            obj.distr_mu = mu;
            obj.distr_sigma = sigma;
            obj.seed_prob = seed_probability;
        end

        function label_prob = response_exact(input)
            %METHOD1 Summary of this method goes here
            %   label_prob = P(label == 'positive')
            if obj.deterministic == true % deterministic labels  
                if input > threshold
                    label_prob = 1;
                else
                    label_prob = 0;
                end
            else % stochastic labels
                if input > threshold
                    label_prob = normrnd(obj.distr_mu,obj.distr_sigma);
                else
                    label_prob = normrnd(1-obj.distr_mu,1-obj.distr_sigma);
                end         
            end
        end

        function label_prob = response_imperfect(input)
            %METHOD1 Summary of this method goes here
            %   label_prob = P(label == 'positive')
            label_prob = obj.response_exact(input);
            reverse_prob = random('Uniform',0,1);
            reverse_thresh = 0.8;
            
            if reverse_prob > reverse_thresh
                label_prob = 1-label_prob;
            end
        end

        function input_sample = provide_input_optimal(lo_bound,hi_bound,delta,prev_sample)
            %METHOD1 Summary of this method goes here
            %
            if prev_sample > obj.true_threshold
                input_sample = max([lo_bound obj.true_threshold-delta]);
            elseif prev_sample < obj.true_threshold
                input_sample = min([hi_bound obj.true_threshold+delta]);
            else
                input_sample = obj.true_threshold;
            end  
        end

        function input_sample = provide_input_seed(lo_bound,hi_bound,delta,prev_sample)
            %METHOD1 Summary of this method goes here
            %
            if prev_sample > obj.true_threshold
                input_sample = max([lo_bound obj.true_threshold-delta]);
            elseif prev_sample < obj.true_threshold
                input_sample = min([hi_bound obj.true_threshold+delta]);
            else
                input_sample = obj.true_threshold;
            end 

            obj.seed_prob = max(0,obj.seed_prob-obj.decrement);
            reverse = (obj.seed_prob < obj.seed_lower_bound);
            if reverse == true
                input_sample = hi_bound-input_sample;
            end
        end

        function input_sample = provide_input_naive(lo_bound,hi_bound)
            %METHOD1 Summary of this method goes here
            %
            input_sample = random('Uniform',lo_bound,hi_bound);
        end

        function label_prob = response_manual
            %METHOD1 Summary of this method goes here
            %
            if obj.deterministic == true
                answer = questdlg('To which class does the current sample belong?', ...
	                            'Sample Labelization', ...
	                            'Positive','Negative');
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
                answer_class = questdlg('To which class does the current sample belong?', ...
	                            'Sample Labelization - Class', ...
	                            'Positive','Negative');
%                 answer_prob = inputdlg('How much do you trust your labelization? [0 = not at all, 1 = completely]', ...
% 	                            'Sample Labelization - Probability', ...
% 	                            'Positive','Negative');
            end
        end

        function input = provide_input_manual
        end

    end

end
