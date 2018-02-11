
%clsfmat is the error matrix
%m is the no. of samples of each person in training sample
%m1 is the no. of samples of each person in test sample
%ns1 is the no. of persons in test sample

function [far,frr,thresh,genc,impc,gen,eq_thresh,gar]=frr_far(m,ns1,m1,clsfmat)
min_t=min(min(clsfmat));
max_t=max(max(clsfmat));

thresh=[min_t:(min_t*30-min_t)/100:min_t*30];
%thresh=[min_t:(max_t-min_t)/100:max_t];
frr=[];
far=[];
genc=[];
impc=[];

for t=thresh
    compare=clsfmat<=t;
    gen=[];
    for j=[1:ns1]
        gen=[gen compare(m*(j-1)+1:j*m,m1*(j-1)+1:j*m1)];
    end
    gen_count=sum((sum(gen)>0));
    imp_count=sum((sum(compare)-sum(gen))>0);
    genc=[genc gen_count];%count of gen per test image
    impc=[impc gen_count];
    frr=[frr (ns1*m1-gen_count)/(ns1*m1)];
    far=[far (imp_count)/(ns1*m1)];
end
sub=abs(far-frr);
index=find(sub==min(sub),1);
eq_thresh=thresh(index);
gar=1-far(index);

end
