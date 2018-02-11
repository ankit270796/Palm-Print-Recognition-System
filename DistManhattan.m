function [RDist,ThetaDist]=DistManhattan(img1,img2,feature_vector)
Rxl=img1(1,1:feature_vector);
Ixl=img1(1,feature_vector:end);
Ryl=img2(1,1:feature_vector);
Iyl=img2(1,feature_vector:end);

RDist = sum(abs(Rxl-Ryl))/3*3.65; 
ThetaDist = sum(abs(Ixl-Iyl));

end