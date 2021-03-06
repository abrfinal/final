function e = getGeneralizationError(predictions)
% input: predictions = 1 by 5120 vector with predictions (1= Endosomes; 2=Lysosomes; 3=Mitochondria; 4=Peroxisomes; 5=Actin; 6=Plasma Membrane; 7=Microtubules; and 8=Endoplasmic Reticulum
% output e = classification error
m = load('trueLabels.mat');m=m.trueLabels;
e = length(find(predictions-m))/length(m);
end