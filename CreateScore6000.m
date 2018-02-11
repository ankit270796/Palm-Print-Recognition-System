tic

clear
close all
total_no_of_person=50;
feature_vector=16;

Red1=load('Red16FirstSession.mat');
Red2=load('Red16SecondSession.mat');
Red=[Red1.Red16FirstSession Red2.Red16SecondSession];

% NIR1=load('NIR_First_Session.mat');
% NIR2=load('NIR_Second_Session.mat');
% NIR=[NIR1.NIR_First_Session NIR2.NIR_Second_Session];

% Green1=load('GreenFirstSession.mat');
% Green2=load('GreenSecondSession.mat');
% Green=[Green1.GreenFirstSession Green2.GreenSecondSession];

%     Blue1=load('BlueFirstSession.mat');
%     Blue2=load('BlueSecondSession.mat');
%     Blue =[Blue1.BlueFirstSession Blue2.BlueSecondSession];

  Feature=Red1.Red16FirstSession;   %%%% feature to be tested 

Score=[];
FinalScore={};
FinalScoreMat=[];
%%% first two loops to pick test images 

for index1=1:total_no_of_person        %%%%%% Samples from the no of people 
    for index2=5:6      %%%%%% Samples from a person
        TestImageFeature=Feature{index1,index2};
        
        %%% these two loops to compare to database
        
        for index3=1:total_no_of_person
           for index4=1:4
              DatabaseImageFeature=Feature{index3,index4};
              [RDist,ThetaDist]=DistManhattan(TestImageFeature',DatabaseImageFeature',feature_vector);
              score(index3,index4)=RDist+ThetaDist;
           end
        end
        
        FinalScore{index1,index2-4}=score;
    end
end

[row,col]=size(FinalScore);
[row1,col1]=size(FinalScore{1,1});

for index5=1:1:row
    for index6=1:1:col
    temp1=FinalScore{index5,index6};
    temp2=reshape(temp1',[row1*col1,1]);
    FinalScoreMat=[FinalScoreMat temp2];
    end
end

invoke(actxserver('SAPI.SpVoice'),'Speak','program is completed');

[far,frr,thresh,genc,impc,gen,eq_thresh,gar]=frr_far(4,total_no_of_person,2,FinalScoreMat);
plot(thresh,far,'r+-','linewidth',2)
hold on
plot(thresh,frr,'b+-','linewidth',2)
FarVar=1-gar;
toc