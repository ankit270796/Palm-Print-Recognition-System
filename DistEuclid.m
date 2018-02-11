function [RDist,ThetaDist]=DistEuclid(img1,img2,feature_vector)

Rxl=img1(1,1:feature_vector);
Ixl=img1(1,feature_vector:end);
Ryl=img2(1,1:feature_vector);
Iyl=img2(1,feature_vector:end);

RDist = sum(sqrt((Rxl-Ryl).*(Rxl-Ryl)))/3.65*16;
ThetaDist = sum(sqrt((Ixl-Iyl).*(Ixl-Iyl)))/16;

end
