w=3;
ra = linspace(-w, w, 1e3+1);
I = exp(-2.* (ra.^2) ./ 1.^2);
step=zeros(1,length(I));
object=50;
step((length(I)+1)/2-object:(length(I)+1)/2+object)=1;
fprintf('FWHM of step function is : %f\n', 2*object)
FWHM(I);
u=conv(step,I,"same");
FWHM(u./max(u));
figure(99),plot(I,'b--');hold on;plot(step,'k--');hold on;plot(u./max(u),'r-');axis tight

function FWHM(H)
H=H./max(H);
a=max(find(H(1:(length(H)-1)/2)<0.5));
b=min(find(H((length(H)-1)/2:end)<0.5))+(length(H)-1)/2;
fprintf('The FWHM of is: %f\n', abs(a-b));
end