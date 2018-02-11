ScoreTheta=[];
ScoreR=[];
TempTheta=[];
TempR=[];

%%% first two loops to pick test images 

for index1=1:1        %%%%%% Samples from the no of people 
    for index2=1:1     %%%%%% Samples from a person
        TestImageFeature=FirstTimeHand(index1,((index2-1)*16+1):(index2*16));
        
        %%% these two loops to compare to database
        
        for index3=2:2
           for index4=3:3
              DatabaseImageFeature=FirstTimeHand(index3,((index4-1)*16+1):(index4*16));
              [RDist,ThetaDist]=DistPaper(TestImageFeature,DatabaseImageFeature);
              TempTheta=[TempTheta ThetaDist];
              TempR=[TempR RDist];
           end
        end
        
    end
    ScoreTheta=[ScoreTheta; TempTheta];
    ScoreR=[ScoreR; TempR];
    TempTheta=[];
    TempR=[];
end
ScoreTheta
ScoreR

            