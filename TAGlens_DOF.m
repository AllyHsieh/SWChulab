clear 
delta=[-10e-6:0.1e-6:10e-6]; %+-10m-1
z=[-100e3:1000e-3:100e3]; 
lambda=0.94; %wavelength=940e-9
omega=5.5e3; %beam radius=1.2*3/2*4/2
f_objective=18e3; %with GRIN:18e3

q0=1/(-1i*lambda/(pi*omega^2));
d=[18e3,200e3,250e3,90e3,100e3,60e3];
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
Mlens=Mgrin*Md(:,:,1)*Mobj*Md(:,:,2)*MTL*Md(:,:,3)*MSL*Md(:,:,4)*ML1*Md(:,:,5)*ML2*Md(:,:,6);
%Mlens=Mobj*Md(:,:,2)*MTL*Md(:,:,3)*MSL*Md(:,:,4)*ML1*Md(:,:,5)*ML2*Md(:,:,6);
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
omegabox(d)=sqrt(lambda*imag(q)/pi);
end
for i=1:(d-1)/2
range(i)=abs(focusz(i)-focusz(end-i+1));
end
figure(1),subplot(221),plot(delta*1e6,focusz);ylabel('focusz(um)');xlabel('diopter')
figure(1),subplot(222),plot(-delta(1:(d-1)/2).*1e6,range);title(['10D = ',num2str(max(range)),' \mum']);ylabel('scanning range');xlabel('optical power')
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