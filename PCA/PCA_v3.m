% Data is any 3D data
f=sum(Data(170:460,80:425,1:81),3)/81;
f(f==0)=-1;
for l=1:809
delta=(Data(170:460,80:425,l)-f)./f;
dataA(:,:,l)=delta;
end
% dataA is the data after df/f calculation
mask_PC=zeros(size(dataA));
A=zeros(size(dataA,1)*size(dataA,2),size(dataA,3));
for time=1:size(dataA,3)
    Xt=dataA(:,:,time);%.*mask;
    A(:,time)=reshape(Xt',[],1);
end

one_vector(1:size(A,1)) = 1;
mu = (one_vector * A) / size(A,1);
meanA = A - mu(one_vector, :);
covA = (meanA.' * meanA) / (size(meanA,1) - 1); %cov(meanA);

tic
[u,value]=eig(covA);
toc

eigvalue=100.*diag(value)./sum(sum(value));
[val,num]=sort(eigvalue,'descend');
U=zeros(size(covA));
for k=1:size(covA,2)
    U(:,k)=u(:,num(k));
end
P=meanA*U;
%
X=reshape(P,size(dataA,2),size(dataA,1),[]);
up=length(find(val>1));
PCA=X(:,:,1)'; %1stPC
figure(188),imagesc(PCA);axis image;title('first principle component')

%show results
for l=1:up
    PCA=X(:,:,l)';
    positive=PCA;
    positive(positive<0)=0;
    negtive=PCA;
    negtive(negtive>=0)=0;
figure(191),subplot(2,up,l),imagesc(positive),axis image,title(['PC',num2str(l),'(',num2str(val(l)),'%)']);colormap jet
figure(191),subplot(2,up,l+up),imagesc(negtive),axis image,title(['PC',num2str(l)]);colormap jet
figure(191),subplot(1,up,l),imagesc(PCA),axis image,title(['PC',num2str(l),'(',num2str(val(l)),'%)']);colormap jet
end

%mapcaplot(A)
figure(8),plot(P(:,1),P(:,2),'.')
%%
PCA=X(:,:,1)';
positive=PCA;
positive(positive<0)=0;
mask=zeros(size(positive));
mask(positive~=0)=1;
figure,imagesc(mask);axis image
save('data_fly1-2_mask','mask')
