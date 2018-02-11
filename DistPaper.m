function [RDist,ThetaDist]=DistPaper(img1,img2)

Rxl=img1(1,1:16);
Ixl=img1(1,16:end);
Ryl=img2(1,1:16);
Iyl=img2(1,16:end);

RDiff = abs(Rxl-Ryl)/2*3.65 ;
RDist = sum(RDiff) ;

%%%%%% Feature Matching By Theta Feature %%%%%
Ixx=sum((Ixl-mean(Ixl)).*(Ixl-mean(Ixl)));
Iyy=sum((Iyl-mean(Iyl)).*(Iyl-mean(Iyl)));
Ixy=sum((Ixl-mean(Ixl)).*(Iyl-mean(Iyl)));
ThetaDist =(1-(Ixy*Ixy)/(Ixx*Iyy))*100;

end