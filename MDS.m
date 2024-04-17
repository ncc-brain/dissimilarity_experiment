
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

        %original distance Matrix

        coloumnNames = {};
        rowNames = {};

        for i = 1: height(distanceMatrix)
            coloumnNames{i} = ['Stimulus',num2str(i)];
            rowNames{i}=['Stimulus',num2str(i)];
        end

        distanceTable = array2table(distanceMatrix,'VariableNames',coloumnNames,'RowNames',rowNames);
        save(fullfile(processedDataPath, 'distanceTable.mat'), 'distanceTable');

        %for the MDS, same pairs' distance (diagonal elements) should be 0
        %table will be altered to ensure this assumption 

    
        for i = 1:height(distanceMatrix)
            distanceMatrix(i, i) = 0;
        end

        %classic (metric) MDS 
        
        [Y, eigvals] = cmdscale(distanceMatrix);

        % Y contains the coordinates of the stimuli 
        % eigvals contains eigenvalues

        % check whether data can be visualized 2D 

        eigenCheck = [eigvals eigvals/max(abs(eigvals))];

        % data can be plotted 2D because first 2 eigenvalues capture the most
        % variance 

        % check reliability of MDS with maximum relative error 
        
        maxrelerr = max(abs(distanceMatrix - squareform(pdist(Y(:,1:2))))) / max(distanceMatrix);

        
        % plot the MDS 

        %plot as stimulus numbers

        %stimulusNames = {'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20'};

        %plot(Y(:,1),Y(:,2),'.')
        %text(Y(:,1),Y(:,2),stimulusNames)
        %xlabel('Distance')
        %ylabel('Distance')

        %plot as images     
        cd(faceImagesPath);
        addpath(genpath(faceImagesPath));

        faceImages = {'Face1Center.png','Face2Center.png','Face3Center.png','Face4Center.png','Face5Center.png','Face6Center.png' ...
            'Face7Center.png','Face8Center.png','Face9Center.png','Face10Center.png','Face11Center.png','Face12Center.png','Face13Center.png','Face14Center.png','Face15Center.png'...
            'Face16Center.png','Face17Center.png','Face18Center.png','Face19Center.png','Face20Center.png'};

        %load the images
        scaleFactor = 0.25; % Specify the scale factor for resizing (e.g., 0.5 for 50%)
        faceImagesCell = {};
        for i = 1:numel(faceImages)
            img = imread(faceImages{i});
            scaledImg = imresize(img, scaleFactor); % Rescale the image
            faceImagesCell{i} = scaledImg;
        end
       
        
        %plot
        
        figure;

        plot(Y(:,1), Y(:,2), '.');

        hold on;

        for i = 1:numel(faceImagesCell)
        scatterimage('XData', Y(i, 1), 'YData', Y(i, 2), 'CData', faceImagesCell{i});
        end
        
        hold off;
       
  