%clear 
delta=[-5e-6:0.1e-6:5e-6]; %+-10m-1
z=[-100e3:500e-3:100e3]; 
lambda=0.94; %wavelength=940e-9
omega=6.3e3; %beam radius=1.2*3/2*4/2
f_objective=7.2e3; %with GRIN:18e3
nmatrix=[1 0;0 1/1.333]; %refractive index
q0=1/(-1i*lambda/(pi*omega^2));
d=[180e3,200e3,250e3,90e3,100e3,60e3];
for i=1:6
    Md(:,:,i)=[1,d(i);0,1];
end
Mobj=[1 0;-1/f_objective 1]; 
MTL=[1 0;-1/200e3 1]; %tube lens
MSL=[1 0;-1/50e3 1]; %scan lens
ML1=[1 0;-1/40e3 1]; %lens1
ML2=[1 0;-1/60e3 1]; %lens2
l1=5.89e3;l2=2.06e3;g1=0.256e-3;g2=0.693e-3;
d3=0.6e3;l3=7.4e3;
g3=2*pi*1.5/l3;n3=2*0.5/(g3*d3); %d=diameter, l=length, 
% n=central refractive index=2NA/gd, g=gradient index=2pi*Pitch/l
 grin2=[1 0;0 1.624/1.333]*[cos(g2*l2) sin(g2*l2)/g2;-sin(g2*l2)*g2 cos(g2*l2)];
 grin1=[1 0;0 1.521/1.624]*[cos(g1*l1) sin(g1*l1)/g1;-sin(g1*l1)*g1 cos(g1*l1)]*[1 0;0 1/1.521];
grin3=[1 0;0 n3/1.333]*[cos(g3*l3) sin(g3*l3)/g3;-sin(g3*l3)*g3 cos(g3*l3)]*[1 0;0 1/n3];
%Mgrin=grin2*grin1;
Mgrin=grin3;

%Mgrin*Mobj*M200*M50*M40*M60*MTAG
%focalZ*d0.1*d200*d250*d90*d100*d60
%Mlens=Mgrin*Md(:,:,1)*Mobj*Md(:,:,2)*MTL*Md(:,:,3)*MSL*Md(:,:,4)*ML1*Md(:,:,5)*ML2*Md(:,:,6);
wd=[1,2e3;0,1]; %working distance wd*nmatrix*
wn=[1 0;0 1/1.333];
Mlens=wn*Mobj*Md(:,:,2)*MTL*Md(:,:,3)*MSL*Md(:,:,4)*ML1*Md(:,:,5)*ML2*Md(:,:,6);
for d=1:length(delta)
    Mtag=[1 0;-delta(d) 1]; %varied
    for dz=1:length(z)
        Mdz=[1,z(dz);0,1];
        tempM=Mdz*Mlens*Mtag;
        realtempq(dz)=real((tempM(1)*q0+tempM(2))/(tempM(3)*q0+tempM(4))); %curvature
    end
[pos,idx]=find(abs(realtempq)==min(abs(realtempq)));
if min(abs(realtempq))>1
    disp(['delta=',num2str(d),'  error'])
    break
end
focusz(d)=z(idx);
Rcurvature(d)=1/realtempq(idx); %radius curvature
m=[1,z(idx);0,1];
M=m*Mlens*Mtag;
Mbox(d)=trace(M);
q=(M(1)*q0+M(2))/(M(3)*q0+M(4));
qbox(d)=q;
omegabox(d)=sqrt(lambda*imag(q)/(pi*1.33));
end
for i=1:(d-1)/2
range(i)=abs(focusz(i)-focusz(end-i+1));
end
figure(1),subplot(221),plot(delta*1e6,focusz);ylabel('focusz(mm)');xlabel('diopter')
originalTicks = yticks;newLabels = 1e-3 * originalTicks;yticklabels(string(newLabels));
figure(1),subplot(222),plot(-delta(1:(d-1)/2).*1e6,range);title(['10D = ',num2str(max(range)),' \mum']);ylabel('scanning range');xlabel('optical power');axis tight
figure(1),subplot(223),plot(delta*1e6,omegabox);ylabel('waist');xlabel('diopter')
    %figure(1),subplot(121),plot(delta,focusz,'o');xlabel('focusz');ylabel('diopter')
%figure(1),subplot(122),plot(delta,abs(omegabox),'o-');xlabel('diopter');ylabel('omega')

%%
da = 0.01; %10nm
a_lim = 0.1e3; %100um
a_N = 2*a_lim/da + 1;
a_range = f_objective - a_lim : da : f_objective + a_lim;
I_a_total = zeros(1,length(a_range));
k = 2*pi/lambda;
%
D_N = size(delta,2);
for i = 1:D_N % 第i個D
    E_a_i = zeros(1,length(a_range));
    for j = 1:length(a_range) % 第j個軸向位置
        z_rel_to_focus = a_range(j)-focusz(i)+1e-3;
        %E_a_i(j) = 1/omegabox(i) * exp(-1i*k*z_rel_to_focus) * 1i/lambda/z_rel_to_focus; % r=0
        E_a_i(j) = exp(-1i*k*z_rel_to_focus^2/omegabox(i)^2);
    end
    I_a_i = abs(E_a_i).^2;
    I_a_total = I_a_total + I_a_i;
end
%
avgN = 1001; % odd
I_avg = zeros(1,a_N);
for i = 1+(avgN-1)/2 : a_N-(avgN-1)/2
    I_avg(i) = mean(I_a_total(1,i-(avgN-1)/2:i+(avgN-1)/2));
end
fwhm=find(I_avg==0);
a=a_range(fwhm(length(fwhm)./2+2));
b=a_range(fwhm(length(fwhm)./2-1));

figure(1),subplot(224),plot(a_range, I_avg, 'r');title(['fwhm=',num2str(abs(a-b)), 'um'])
xlabel('Axial Position');ylabel('Total Intensity')

%%

minVal = focusz(1);
maxVal = focusz(end);
numPoints = length(focusz); 
x = linspace(-pi/2, pi/2, numPoints);
y = sin(x); 
y_normalized = (y - min(y)) / (max(y) - min(y));

values = minVal + y_normalized * (maxVal - minVal);

figure,plot(values, 'o-');
xlabel('Point Index');
ylabel('Value');
title('Non-uniform Distribution of Values');
%%
NA=0.53;
x=[-pi/2:0.01:pi/2];
track=sin(x);
distance=0.532*lambda*sqrt(2*log(2))/(1.33-sqrt(1.33^2-NA^2))
w=distance/(2*sqrt(2)*log(2)^(0.25))*10;
%w=omegabox.*1e7;
r = linspace(-4*w/2,4*w/2, 2e2+1); % beam size
I_0 = 1;
% 設定參數
mu = 0;    % 平均值
sigma = w*0.76; % 標準差


% 計算高斯函數值
E = I_0* exp(-(r-mu).^2 / (2*sigma^2)); %*(1/(sigma*sqrt(2*pi))) 

beam=E.^2;

figure(2),plot(beam);axis tight


%%
minVal = focusz(1);
maxVal = focusz(end);
x = linspace(-pi/2, pi/2, 10*length(focusz)); 
y = sin(x); 
y_normalized = (y - min(y)) / (max(y) - min(y));
values = minVal + y_normalized * (maxVal - minVal);
v=(values).*10;
figure(9),plot(v);axis tight
%%
I=beam;
%I=conv(beam,FLB);
c=(length(I)-1)/2;
g=zeros(1,max(v)+c);
for i=1:length(v)
r=zeros(1,max(v)+c);
    pos=v(i);
    r(pos-c:pos+c)=I;
    g=g+r;
    %figure(8),plot(g(90000:end));hold on
end
t= find(g~=0);
Pos=[t(1)-10:t(end)];
Pos=Pos-min(Pos);
g=g./max(g);
figure(11),subplot(224),plot(Pos,g(t(1)-10:t(end)))
figure(12213),plot(Pos,g(t(1)-10:t(end)));axis tight

originalTicks = xticks;
newLabels = 1e-1 * originalTicks;
xticklabels(string(newLabels));
%
I=g(t(1)-10:end);
[pks,locs] = findpeaks(I);
h= sort(pks,'descend');
rightmax = find(I==h(1));
leftmax = find(I==h(2));
if rightmax<leftmax
    t=[rightmax,leftmax];
    rightmax=t(2);
    leftmax=t(1);
end
half_max=(I(rightmax)-min(I))/2;
[~,maxnum]=min(sqrt(I(rightmax:end).^2-half_max^2));
maxnum=maxnum+rightmax;
[~,minnum]=min(sqrt(I(1:leftmax).^2-half_max^2));
FWHM=abs(maxnum-minnum);

fprintf('The FWHM is: %f\n', FWHM*1e-1);
title(['fwhm=',num2str(FWHM*1e-1), 'um'])
xlabel('Axial Position (um)');ylabel('Total Intensity')

%% convolution
beamsize=10*1e1; %um*1e1
FLB = zeros(1,length(beam));
half=(length(beam)-1)/2;
FLB(half-beamsize/2:half+beamsize/2)=1;

covlution=conv(FLB,beam);
shift=round(length(covlution)/4);
figure(13),plot(beam),axis tight;hold on
plot([1:length(covlution)]-shift,covlution./max(covlution),'--');
plot(FLB)