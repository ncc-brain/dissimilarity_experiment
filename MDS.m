
% This script computes multidimensional scaling (MDS)
% classic MDS applied on non-spatial distances

clear
clc
addpath('./');
config;

cd(processedDataPath)
addpath(genpath(processedDataPath));

%load data and compute MDS

load("FaceMeanRatingsTable.mat");
faceMeanRatingData = meanRatingsTable;
MDSface = MDSFunction(faceMeanRatingData,'Face');

load("ObjectMeanRatingsTable.mat");
objectMeanRatingData = meanRatingsTable;
MDSobject = MDSFunction(objectMeanRatingData,'Object');


%% MDS check for number of eigenvalues and error rate before plotting the graphs
   %check how many eigenvalues are high and how many of them are negative
   %it should be first 2 values significantly higher than others 
   eigenCheckObject = [MDSobject{2} MDSobject{2}/max(abs(MDSobject{2}))]; 
   eigenCheckFace = [MDSface{2} MDSface{2}/max(abs(MDSface{2}))];  
   
   %check the error rate --> 'error in the distances between the 2D configuration and the original distances'
   load("FaceDistanceMatrix.mat")
   faceDistanceMatrix = distanceTable;
   
   load("ObjectDistanceMatrix.mat")
   objectDistanceMatrix = distanceTable;
   
   maxrelerrFace = max(abs(table2array(faceDistanceMatrix) - squareform(pdist(MDSface{1}(:,1:2))))) / max(table2array(faceDistanceMatrix));
   maxrelerrObject = max(abs(table2array(objectDistanceMatrix) - squareform(pdist(MDSobject{1}(:,1:2))))) / max(table2array(objectDistanceMatrix));
%% Plot the data 

figure;
        stimulusNames = {'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20'};
        xlabel('Distance')
        ylabel('Distance')
        %plot(Y(:,1),Y(:,2),'.')       
 hold on
        %plot as images 

        cd(faceImagesPath);
        addpath(genpath(faceImagesPath));

        faceImages = {'Face1Center.png','Face2Center.png','Face3Center.png','Face4Center.png','Face5Center.png','Face6Center.png' ...
            'Face7Center.png','Face8Center.png','Face9Center.png','Face10Center.png','Face11Center.png','Face12Center.png','Face13Center.png','Face14Center.png','Face15Center.png'...
            'Face16Center.png','Face17Center.png','Face18Center.png','Face19Center.png','Face20Center.png'};
allImages = {};
for i = 1:numel(faceImages)
currentImage = imread(faceImages{i});
allImages{i} = currentImage;
end

stimulusNames = {'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20'};

for j = 1: numel(allImages)

image('XData',[Y(j,1)-1 Y(j,1)+1],'YData',[Y(j,2)-1 Y(j,2)+1],'CData',flipud(cell2mat(allImages(j)))); %rescale the images
text(Y(j,1),Y(j,2),stimulusNames{j})

 hold on

end
colormap gray
hold off



 