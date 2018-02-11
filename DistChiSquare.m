
function [RDist,ThetaDist]=DistChiSquare(img1,img2,feature_vector)

Rxl=img1(1,1:feature_vector);
Ixl=img1(1,feature_vector:end);
Ryl=img2(1,1:feature_vector);
Iyl=img2(1,feature_vector:end);

RDist = 2*sum(((Rxl-Ryl)./(Rxl+Ryl)).^2);
ThetaDist = 2*sum(((Ixl-Iyl)./(Ixl+Iyl)).^2);

end
