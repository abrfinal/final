function loss = computeLoss(data, labels, models, overall_model_prediction)
    final_predictions = zeros(size(data,1),1);

    each_round_prediction = getBatchPredictions(models, data);
    
    for i = 1 : size(each_round_prediction,1)
        each_prediction = each_round_prediction(i,:);
        positive_result_num = length(each_prediction(each_prediction ~= 0));
        if positive_result_num ==1
            final_predictions(i) = each_prediction(each_prediction ~= 0);
        elseif positive_result_num == 0
            
            % choice 1: randomly choose one
            % final_predictions(i) = randi(length(models));
            
            % choice 2: choose nothing
            % final_predictions(i) = 0;

            % choice 3 : choose the overall predictions
            final_predictions(i) = overall_model_prediction;
            
        else
            % choice 1: randomly choose one
            % positive_results = each_prediction(each_prediction ~= 0);
            % multiple positive results selection strategy
            % predicted_label = datasample(positive_results, 1);
            % final_predictions(i) = predicted_label; % randomly selected
            
            % choice 2: choose the first one
            % positive_results = each_prediction(each_prediction ~= 0);
            % final_predictions(i) = positive_results(1); 
            
            % choice 3 : choose the overall predictions
            final_predictions(i) = overall_model_prediction;
        end
    end
    % MAE mean absolute error
    predict_minus_label = final_predictions - labels';
    error_nums = length(predict_minus_label(predict_minus_label ~= 0));
    loss = error_nums/length(labels);

end