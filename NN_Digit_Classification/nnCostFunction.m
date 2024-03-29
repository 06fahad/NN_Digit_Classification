function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

% Add ones to the X data matrix
X = [ones(m, 1) X];

%Prepare y_mat for use in computing cost
y_mat = zeros([length(y), num_labels]);
for i=1:size(y_mat, 1)
    for j = 1:size(y_mat, 2)
        if y(i) == j
           y_mat(i, j) = 1;
        else
            y_mat(i, j) = 0;
        end
    end
end
%forwardprop implementation
Z2 = X*transpose(Theta1); %A1 should be 5000x25
A2 = sigmoid(Z2);
A2 = [ones(m, 1) A2]; % Add ones to the A1 data matrix A1 = 5000x26
Z3 = A2*transpose(Theta2); %Z2 should be 5000x10
A3 = sigmoid(Z3);
hyp = A3;


%Prepare regularization terms
reg_theta1 = Theta1(1:size(Theta1, 1), 2:size(Theta1, 2));
reg_theta2 = Theta2(1:size(Theta2, 1), 2:size(Theta2, 2));
sum_reg_theta1 = sum(reg_theta1.^2);
sum_reg_theta2 = sum(reg_theta2.^2);
reg = (lambda/(2*m))*(sum(sum_reg_theta1) + sum(sum_reg_theta2));

%Compute regularized cost function
J_int1 = ((-y_mat).*(log(hyp)) - (1.-y_mat).*(log(1-hyp)));
J = (1/m)*sum(J_int1, 'all') + reg;


% -------------------------------------------------------------
%Backprop implementation

delta_3 = hyp - y_mat;
delta_2 = (delta_3 * Theta2(:, 2:end)).*sigmoidGradient(Z2);
Delta1 = transpose(delta_2)*X;
Delta2 = transpose(delta_3)*A2;
Theta1_grad = (1/m).*Delta1;
Theta2_grad = (1/m).*Delta2;
% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
