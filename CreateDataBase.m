tic
clear
close all
FirstTimeHand={};
SecondTimeHand={};
feature_vector=16;

for i=1:1:50
   for j=1:1:8
   imgF=strcat('C:\Users\ankit\Desktop\MATLAB Codes\Palm Print\DATABASE\PolyU_',num2str(i),'_F_',num2str(j),'.bmp');
   imgS=strcat('C:\Users\ankit\Desktop\MATLAB Codes\Palm Print\DATABASE\PolyU_',num2str(i),'_S_',num2str(j),'.bmp');

 %%%%%%%%%% Database First Set Image %%%%%%%%%%%%
 
Img = imread(imgF);
Grayscale = Img;         %%%%% convert to Grayscale for the RGB image %%%%%
[m,n]=size(Grayscale);
FourTrans = fft2(Grayscale);
Shift=fftshift(FourTrans);
Absolute = abs(Shift);
MaxVal = max(max(Absolute));
Abs=(Absolute/MaxVal)*255;

%%Second set image from the database 

ImgBase = imread(imgS);
GrayscaleBase = ImgBase;    %%%%%%%% convert to grayscale for RGB image
GrayscaleBase = imresize(GrayscaleBase,[m n]);
FourTransBase = fft2(GrayscaleBase);
ShiftBase=fftshift(FourTransBase);
AbsoluteBase = abs(ShiftBase);
MaxValBase = max(max(AbsoluteBase));
AbsBase=(AbsoluteBase/MaxValBase)*255;


%%%%%%%% Calculation of energies in circles %%%%%%%%
%%%%% R(i) is energy in ith circle; i is [1,8] %%%%%

[X,Y] = meshgrid(1:n,1:m);    %%% Y denotes row and X columns matrix
                              %%% both Y and X matrix are m*n

M = floor(m/2);               %%% (N,M) is the center of circle
N = floor(n/2);
Radius = min([m,n])/2;
step = Radius/feature_vector;

region = step:step:(Radius-step);    %%%% defines circular regions %%%%
Rx=zeros(feature_vector,1);
Ry=zeros(feature_vector,1);
Filter=zeros(m,n);
TempFilter=0;

for i1=1:1:feature_vector-1
   Filter(sqrt((Y-M).^2+(X-N).^2)<region(1,i1))=1;
   Rx(i1)=sum(sum((Filter-TempFilter).*Abs));
   Ry(i1)=sum(sum((Filter-TempFilter).*AbsBase));
   TempFilter=Filter;
end
   Filter=zeros(m,n);
   Filter(sqrt((Y-M).^2+(X-N).^2)>region(1,feature_vector-1))=1;
   Rx(feature_vector)=sum(sum(Filter.*Abs));
   Ry(feature_vector)=sum(sum(Filter.*AbsBase));
   
 
%%%%% Calculation of energy in fins %%%%%%
%%%%% I(i) is energy in ith fin; i is [1,8]

Fin = pi:-pi/feature_vector:0;
Ix=zeros(feature_vector,1);
Iy=zeros(feature_vector,1);
Filter=zeros(m,n);

for i2=1:1:feature_vector
    Filter((atan2(M-Y,N-X)>Fin(1,i2+1))&(atan2(M-Y,N-X)<Fin(1,i2)))=1;
    %%% convolution to the fourier transformed value
    Ix(i2)=sum(sum(Filter.*Abs));
    Iy(i2)=sum(sum(Filter.*AbsBase));
    Filter=zeros(m,n);
end

FirstTimeHand{i,j}=[Rx' Ix'];
SecondTimeHand{i,j}=[Ry' Iy'];
   end
end
toc

