a1=zeros(1,500);
a2=zeros(1,500);
index=1;
a3=zeros(1,500);
a3(1,1:50)=1;
figure
for i=5:10:25
a2(1,1:i)=1;
a1(1,(500-i):end)=1;
A=[a1 a2];
FtA=fft(A);
shiftA=fftshift(FtA);
Abs=abs(shiftA);
subplot(3,2,index);
plot(A)
subplot(3,2,index+1)
plot(Abs)
index=index+2;
obw(A)
end;
