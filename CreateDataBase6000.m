tic

FirstSession={};
SecondSession={};

FolderIndex=0;
No_Of_Images=6;
Subfolder_No=500;
Std_Image_Size=128;

feature_vector=12;

while(FolderIndex<Subfolder_No)
    FolderIndex=FolderIndex+1;
    ImagePointer=0;
    while(ImagePointer<No_Of_Images)
        ImagePointer=ImagePointer+1;
        
 %%%%%%%%%%%%%% First Session %%%%%%%%%%%%%%%%%
imgF=strcat('C:\Users\Ankit Yadav\Downloads\ROI Database\Red\',num2str(FolderIndex,'%04.f'),'\1_0',int2str(ImagePointer),'_s','.jpg');

 %%%%%%%%%%%%%% Second Session %%%%%%%%%%%%%%%%
imgS=strcat('C:\Users\Ankit Yadav\Downloads\ROI Database\Red\',num2str(FolderIndex,'%04.f'),'\2_0',int2str(ImagePointer),'_s','.jpg');
 
%%%%%%%%%% First Session from the database %%%%%%%%%%%%
Img = imread(imgF);
Grayscale = imresize(Img,[Std_Image_Size Std_Image_Size]);        
FourTrans = fft2(Grayscale);
Shift=fftshift(FourTrans);
Absolute = abs(Shift);
MaxVal = max(max(Absolute));
Abs=(Absolute/MaxVal)*255;

%%%%%%%%%% Second session from the database %%%%%%%%%%%%%

ImgBase = imread(imgS);
GrayscaleBase = imresize(ImgBase,[Std_Image_Size Std_Image_Size]);
FourTransBase = fft2(GrayscaleBase);
ShiftBase=fftshift(FourTransBase);
AbsoluteBase = abs(ShiftBase);
MaxValBase = max(max(AbsoluteBase));
AbsBase=(AbsoluteBase/MaxValBase)*255;

%%%%%%%% Calculation of energies in circles %%%%%%%%
%%%%% R(i) is energy in ith circle; i is [1,8] %%%%%

[X,Y] = meshgrid(1:Std_Image_Size,1:Std_Image_Size);    %%% Y denotes row and X columns matrix
M = floor(Std_Image_Size/2);               %%% (N,M) is the center of circle
N = floor(Std_Image_Size/2);
Radius = Std_Image_Size/2;
step = Radius/feature_vector;
region = step:step:(Radius-step);    %%%% defines circular regions %%%%
Rx=zeros(feature_vector,1);
Ry=zeros(feature_vector,1);
Filter=zeros(Std_Image_Size,Std_Image_Size);
TempFilter=0;

for i1=1:1:feature_vector-1
   Filter(sqrt((Y-M).^2+(X-N).^2)<region(1,i1))=1;
   Rx(i1)=sum(sum((Filter-TempFilter).*Abs));
   Ry(i1)=sum(sum((Filter-TempFilter).*AbsBase));
   TempFilter=Filter;
end
   Filter=zeros(Std_Image_Size,Std_Image_Size);
   Filter(sqrt((Y-M).^2+(X-N).^2)>region(1,feature_vector-1))=1;
   Rx(feature_vector)=sum(sum(Filter.*Abs));
   Ry(feature_vector)=sum(sum(Filter.*AbsBase));
   
 
%%%%% Calculation of energy in fins %%%%%%
%%%%% I(i) is energy in ith fin; i is [1,8]

Fin = pi:-pi/feature_vector:0;
Ix=zeros(feature_vector,1);
Iy=zeros(feature_vector,1);
Filter=zeros(Std_Image_Size,Std_Image_Size);

for i2=1:1:feature_vector
    Filter((atan2(M-Y,N-X)>Fin(1,i2+1))&(atan2(M-Y,N-X)<Fin(1,i2)))=1;
    %%% convolution to the fourier transformed value
    Ix(i2)=sum(sum(Filter.*Abs));
    Iy(i2)=sum(sum(Filter.*AbsBase));
    Filter=zeros(Std_Image_Size,Std_Image_Size);
end

FirstSession{FolderIndex,ImagePointer}=[Rx ; Ix];
SecondSession{FolderIndex,ImagePointer}=[Ry ; Iy];
       
end
end


invoke(actxserver('SAPI.SpVoice'),'Speak','program is completed');
time=toc