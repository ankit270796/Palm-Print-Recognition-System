Score=[];
FinalScore={};
FinalScoreMat=[];
%%% first two loops to pick test images 

No_Of_people=50;

for index1=1:No_Of_people        %%%%%% Samples from the no of people 
    for index2=6:8     %%%%%% Samples from a person
        TestImageFeature=FirstTimeHand{index1,index2};
        
        %%% these two loops to compare to database
        
        for index3=1:50
           for index4=1:5
              DatabaseImageFeature=FirstTimeHand{index3,index4};
              [RDist,ThetaDist]=DistManhattan(TestImageFeature,DatabaseImageFeature,8);
              score(index3,index4)=RDist+ThetaDist;
           end
        end
        FinalScore{index1,index2-5}=score;
    end
end

[row,col]=size(FinalScore);
[row1,col1]=size(FinalScore{1,1});

for index5=1:1:row
    for index6=1:1:col
    temp1=FinalScore{index5,index6};
    temp2=reshape(temp1',row1*col1,1);
    FinalScoreMat=[FinalScoreMat temp2];
    end
end


[far,frr,thresh,genc,impc,gen,eq_thresh,gar]=frr_far(5,No_Of_people,3,FinalScoreMat);
plot(thresh,far,'r+-','linewidth',2)
hold on
plot(thresh,frr,'b+-','linewidth',2)
FarVar=1-gar;

