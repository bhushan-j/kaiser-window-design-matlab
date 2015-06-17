clear all
close all
delta=0.05;
CIN=304440791; %Enter your CIN
wp=CIN*pi/(29000000);%Passband Frequency
ws=CIN*pi/(12000000);%Stopband Frequency
delta_W=(ws-wp)/1000;%transition width
A=-(20*log10(delta));% attenuation
M=((A-8)/(2.285*delta_W));%Number taps
% beta calculation
if (mod(M,2)==0)
M=M-1;
end
alfa=round((M-1)/2);
if(A>50)
beta=0.1102*(A-8.7);
end
if (A>=21 && A<=50)
beta=0.5842*((A-2)^0.4)+0.7886*(A-21);
end
if (A<21)
beta=0;
end
wc=(ws+wp)/2; %Cutoff Frequency
n=0:1:M-1;

h(n+1)=(sin(wc*(n-alfa)))/(pi*(n-alfa));

h(alfa+1)=wc/pi;% ideal impulse respoance

besseli(0,beta);%modified Bessel function
u=sqrt(1-((n-alfa)/(alfa)).^2);
w= besseli(0,(u))/(besseli(0,beta));%to compute kaiser window coeffient
h2=h.*w; %the impulse response of kaiser window
b=h2;% coeffient of numerater of H(Z)
a=1;% coeffient of Denominator of H(Z) 

%FIR Low Pass Filter -Kaiser Window Coeffient
figure
plot(n,w);%the kaiser window coeffient ploting
grid on %grid lines for the current axes

%Impulse Response of Kaiser Windowed FIR LPF Filter
figure
plot(h2)%

%Magnitude Phase Response
figure
freqz(b,a);%to return the frequency response
grid on %to display the major grid lines for the current axes

%Poles and Zeros
figure
[z,p,k]=tf2zpk(b,a);
zplane(z,p);

% Input Signal: Summation of three sinusoidal signals of 50Hz, 150Hz and
%200Hz
figure(5)% Input
f1=50;%Hz
f2=100;%Hz
f3=200;%Hz
t =(0:0.001:0.5);
subplot(3,1,1);
x1=sin(2*pi*f1*t);%50 Hz sin wave
x2=sin(2*pi*f2*t);%100 Hz sin wave
x3=sin(2*pi*f3*t);%200 Hz sin wave
plot(t,x1) %plot 50 Hz sin wave
plot(t,x2) %plot 100 Hz sin wave
plot(t,x3) %plot 200 Hz sin wave
x=x1+x2+x3;
subplot(3,1,2);%to divide the current figure into an 3-by-1 grid and 
%creates an axes for a subplot in the position specified by 2
plot(t, x);%to plot the data in x versus the corresponding values in t
grid;
title('Input signal ')
subplot(3,1,3);
y=filter(b,a,x);%to filter the input data x
plot(y);
grid on %to display the major grid lines for the current axes
title('Output of signal from Kaiser Windowed FIR LPF Filter ');