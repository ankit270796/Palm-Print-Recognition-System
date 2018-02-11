%% Sample image for test
Img = imread('C:\Users\ankit\Desktop\MATLAB Codes\Palm Print\DATABASE\PolyU_8_F_4.bmp');
Grayscale = Img;
[m,n]=size(Grayscale);
imshow(Grayscale);
figure;
FourTrans = fft2(Grayscale);
Shift=fftshift(FourTrans);
Absolute = abs(Shift);
MaxVal = max(max(Absolute));
Abs=(Absolute/MaxVal)*255;
imshow(Abs);


%%image from the database 
ImgBase = imread('C:\Users\ankit\Desktop\MATLAB Codes\Palm Print\DATABASE\PolyU_8_F_8.bmp');
GrayscaleBase = ImgBase;
GrayscaleBase = imresize(GrayscaleBase,[m n]);
figure;
imshow(GrayscaleBase);
figure;
FourTransBase = fft2(GrayscaleBase);   

ShiftBase=fftshift(FourTransBase);
AbsoluteBase = abs(ShiftBase);
MaxValBase = max(max(AbsoluteBase));
AbsBase=(AbsoluteBase/MaxValBase)*255;
imshow(AbsBase);


%%%%%% Calculation of energies in circles %%%%%%%
%%%%% R(i) is energy in ith circle; i is [1,8]

[X,Y] = meshgrid(1:n,1:m);    %%% Y denotes row and X columns matrix
                              %%% both Y and X matrix are m*n

M = floor(m/2);               %%% (N,M) is the center of circle
N = floor(n/2);
Radius = min([m,n])/2;
step = Radius/8;

region = step:step:(Radius-step);    %%%% defines circular regions %%%%
Rx=zeros(8,1);
Ry=zeros(8,1);
Filter=zeros(m,n);
TempFilter=0;

for i=1:1:7
   Filter(sqrt((Y-M).^2+(X-N).^2)<region(1,i))=1;
   figure;
   imshow(Filter-TempFilter); %%% Filter for energy in Circular contours %%%
   Rx(i)=sum(sum((Filter-TempFilter).*Abs));
   Ry(i)=sum(sum((Filter-TempFilter).*AbsBase));
   TempFilter=Filter;
end
   Filter=zeros(m,n);
   Filter(sqrt((Y-M).^2+(X-N).^2)>region(1,7))=1;
   imshow(Filter);  %%% Filter for energy extraction in circular region %%%
   Rx(8)=sum(sum(Filter.*Abs))
   Ry(8)=sum(sum(Filter.*AbsBase))
   
 
%%%%% Calculation of energy in fins %%%%%%
%%%%% I(i) is energy in ith fin; i is [1,8]

Fin = pi:-pi/8:0;
Ix=zeros(8,1);
Iy=zeros(8,1);
Filter=zeros(m,n);

for i=1:1:8
    Filter((atan2(M-Y,N-X)>Fin(1,i+1))&(atan2(M-Y,N-X)<Fin(1,i)))=1;
    figure;
    imshow(Filter);  %%%%%%%%% Filter for Energy Calc in a fin %%%%%%%%%% 
    figure;
    imshow(Filter.*Abs);   %%%%%%%%% Energy in a Fin %%%%%%%%%
    %%% convolution to the fourier transformed value
    Ix(i)=sum(sum(Filter.*Abs));
    Iy(i)=sum(sum(Filter.*AbsBase));
    Filter=zeros(m,n);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Feature Matching By R Feature %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  RDiff = abs(Rx-Ry)/8 ;
  RDist = sum(RDiff) ;

%%%%%% Feature Matching By Theta Feature %%%%%
Ixx=sum((Ix-mean(Ix)).*(Ix-mean(Ix)));
Iyy=sum((Iy-mean(Iy)).*(Iy-mean(Iy)));
Ixy=sum((Ix-mean(Ix)).*(Iy-mean(Iy)));
ThetaDist =(1-(Ixy*Ixy)/(Ixx*Iyy))*100;
 
if((ThetaDist==0)&&(RDist==0))
    fprintf('Perfect Match\n');
else
    fprintf('Does not Match Perfectly\n');
end

Distance = [RDist ThetaDist]       %%%%% Distance Using mathod given in paper 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Euclid Distance %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

EuclidDist = [sum(sqrt((Rx-Ry).*(Rx-Ry))) sum(sqrt((Ix-Iy).*(Ix-Iy)))]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Manhattan Distance %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ManhattanDist = [sum(sum(abs(Rx-Ry))) sum(sum(abs(Ix-Iy)))]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% Chi Square %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ChiSquare = [sum(2*[(Rx-Ry)./(Rx+Ry)].^2) sum(2*[(Ix-Iy)./(Ix+Iy)].^2)]

