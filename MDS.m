
% This script is for multidimensional scaling (MDS)
%classic MDS applied on non-spatial distances

clear
clc
addpath('./');
config;

cd(processedDataPath)
addpath(genpath(processedDataPath));

load("FaceMeanRatingsTable.mat")

% aggregate ratings into one rating

% mean score per row

    rowMeans = {}; 

for i = 1:height(meanRatingsTable)
    rowMean = mean(meanRatingsTable(i,3:end),"all");
    rowMeans{i} = rowMean;
end

    rowMeans = vertcat(rowMeans{:});

% MDS suitable table 
    
    stimulusTable = array2table([meanRatingsTable.Stimulus1,meanRatingsTable.Stimulus2],"VariableNames",{'Stimulus1','Stimulus2'});
    MDStable = [stimulusTable,rowMeans];

% generate dissimilarity matrix

    stimuliIDs = unique([meanRatingsTable.Stimulus1; meanRatingsTable.Stimulus2]); % this one looks unique stimulus IDs
    
    dissimilarityMatrix = []; % it is gonna be 20X20 matrix

    for i= 1:height(meanRatingsTable)

        % go through all the rows, get stimuli and their dissimilarity
        % score

        stimulus1 = MDStable.Stimulus1(i);
        stimulus2 = MDStable.Stimulus2(i);
        dissimilarityScore = MDStable.mean(i);

        % find which unique stimuli ID 

        stim1 = find(stimuliIDs == stimulus1);
        stim2 = find(stimuliIDs == stimulus2);

        dissimilarityMatrix(stim1, stim2) = dissimilarityScore;
        dissimilarityMatrix(stim2, stim1) = dissimilarityScore; % for the symetric matrix

    end
       
        % in the current dissimilarity Matrix, higher values mean higher
        % similarity and lower values mean higher dissimilarity [distance]
        % before MDS, we will convert similarity scores to distance scores 
        
        constant = max(dissimilarityMatrix(:)); % highest value 
        distanceMatrix = constant - dissimilarityMatrix;

        %for the MDS, same pairs' distance should be 0
        %table will be altered to ensure this assumption 

        %classic (metric) MDS 
        
        %[Y, eigvals] = cmdscale(dissimilarityMatrix);

        % Y contains the coordinates of the stimuli 
        % eigvals contains eigenvalues



        


  