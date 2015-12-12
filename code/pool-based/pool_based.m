%% Pool based active learning for image classification, up to 512 oracle call
% load data
data = load_data;

% constant definition
INITIAL_SIZE = 50;
ORACLE = 512;
SELECT_SIZE = ORACLE - INITIAL_SIZE;

% inital variable
loss = zeros(SELECT_SIZE, 1);

% extract initial training data
[training_data, training_index] = datasample(data, INITIAL_SIZE);
[rest_data, ~] = removerows(data, 'ind', training_index);
% inital classifier
model = fitcecoc(training_data(:,1:end-1), training_data(:,end), 'FitPosterior', 1);
for i = 1:SELECT_SIZE
    % make predictions
    display(sprintf('round %d is running', i))
    [predictions, ~, ~, Posterior] = predict(model, rest_data(:, 1:end-1));

    % compute entropy based on posterior probability
    entropy = -Posterior .* log2(Posterior);
    entropy_sum = sum(entropy, 2);
    % get the index of observation with max entropy
    [~, max_entropy_index] = max(entropy_sum);
    % get the observation with max entropy
    max_entropy_observation = rest_data(max_entropy_index);
    [rest_data, ~] = removerows(rest_data, 'ind', max_entropy_index);

    % merge new observation with training data
    training_data = [training_data; max_entropy_observation];

    % retrain the model
    model = fitcecoc(training_data(:,1:end-1), training_data(:,end), 'FitPosterior', 1);

    % calculate the loss
    loss(i) = computeLoss(model, data);
end
plot(loss);