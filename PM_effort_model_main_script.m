
%%Script for running effort based decision-making model for self and other.
%%Calls functions run_pats_prosocial_motivation_model that uses fminsearch
%%to run models with different numbers of parameters
%%then calls visualize_model function to plot the parmeters from the
%%different models, do model comparison and save in a variable called
%%output. In output the parameters of the model (k and beta values depending on what model was run) 
% are stored in output for each subject so they can be
%%correlated with other other measures
%%Written by Pat Lockwood based September 2016

%% 1. Loads in data to do modelling

clear all;

dir_data= 'C:\Users\yangy\Documents\MATLAB\Wepsilon'; % where your data files are
dir_analysis='C:\Users\yangy\Documents\MATLAB\Wepsilon'; % where your analysis files are, e.g. this script and each model function

cd(dir_data);

pick_sample=4;  %% specify which sample to pick as three different samples in original study. 
                %%Each datafile contains varibles that specify for each subject ther effort level, reward level, agent, choice
                %% these variables are stored in a seperate variable called data.chosen data.effort etc where each column is a subject and each row is a trial
                
if pick_sample==1;
      
    numsubs=48;   % specify number of subjects
    
    load model_data.mat % Load the sorted data file
    
elseif pick_sample==2;
    
    numsubs=45;
    
    load data_win.mat
    
elseif pick_sample==3;
    
    numsubs=45;
    
    load data_lose.mat
    
elseif pick_sample ==4;
    
    numsubs=101;
    
    load datos_long_transformed.mat;
end

cd(dir_analysis)

%% Modelling
%%%%%%%%%

%%% 1. Run models:
% runs a function called 'run_pats_prosocial_motivation_model' that takes
% the model ID and runs each of the different models with different
% discount (k) and temperature (beta) parameters

allmodels.onekonebeta                = run_pats_prosocial_motivation_model(data, pick_sample,'one_k_one_beta');            % Parabolic model with one discount rate (k) and one beta
allmodels.twokonebetamodel           = run_pats_prosocial_motivation_model(data, pick_sample,'two_k_one_beta');            % Parabolic model with two discount rates (k) and one beta
allmodels.onektwobetamodel           = run_pats_prosocial_motivation_model(data, pick_sample,'one_k_two_beta');            % Parabolic model with one discount rates (k) and two betas
allmodels.twoktwobetamodel           = run_pats_prosocial_motivation_model(data, pick_sample,'two_k_two_beta');            % Parabolic model with two discount rates (k) and two betas
% allmodels.onekonebetamodellinear     = run_pats_prosocial_motivation_model(data, pick_sample,'one_k_one_beta_linear');     % linear model with one discount rate (k) and one beta
% allmodels.twokonebetamodellinear     = run_pats_prosocial_motivation_model(data, pick_sample,'two_k_one_beta_linear');     % linear model with two discount rates (k) and one beta
% allmodels.twoktwobetamodellinear     = run_pats_prosocial_motivation_model(data, pick_sample,'two_k_two_beta_linear');     % linear model with two discount rates (k) and two betas
% allmodels.onektwobetamodellinear     = run_pats_prosocial_motivation_model(data, pick_sample,'one_k_two_beta_linear');     % linear model with one discount rates (k) and two betas
% allmodels.onekonebetamodelhyperbolic = run_pats_prosocial_motivation_model(data, pick_sample,'one_k_one_beta_hyperbolic'); % hyperbolic model with one discount rate (k) and one beta
% allmodels.twokonebetamodelhyperbolic = run_pats_prosocial_motivation_model(data, pick_sample,'two_k_one_beta_hyperbolic'); % hyperbolic model with two discount rates (k) and one beta
% allmodels.twoktwobetamodelhyperbolic = run_pats_prosocial_motivation_model(data, pick_sample,'two_k_two_beta_hyperbolic'); % hyperbolic model with two discount rates (k) and two betas
% allmodels.onektwobetamodelhyperbolic = run_pats_prosocial_motivation_model(data, pick_sample,'one_k_two_beta_hyperbolic'); % hyperbolic model with one discount rate (k) and two betas


%%% 2. Visualize and compare models:
% runs a function called visualize model that does the model comparison
% with AIC and BIC and plots some of the key variables
output = visualize_model_PM(allmodels,'onekonebeta',[1 0]);

%%% 3. Get discount (k) parameters for correlations:
% make a new variable called output that saves the k and beta parameters
% for the specific models you are interested in to run correlations with
% individual differences.

for j=1:numsubs;
    
output.param2K2B(j,:) = allmodels.twoktwobetamodel{1,j}.x;
output.param2K1B(j,:) = allmodels.twokonebetamodel{1,j}.x;

end


