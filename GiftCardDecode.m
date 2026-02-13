%% OFDM DECODER
clear
close all

% EXTRACT PILOT TIME SIGNAL
[xp, fs] = audioread('GiftCardPilot.wav');
xp = xp(:,1) .+ j.*xp(:,2); % place in single array as I + jQ

% EXTRACT DATA TIME SIGNAL
xd = audioread('GiftCardData.wav')
xd = xd(:,1) .+ j.*xd(:,2);  % place in single array as I + jQ

% COMPUTE PILOT AND DATA SIGNAL FOURIER COEFFICIENTS WITH FFT
Xp = fftshift(fft(xp));
Xd = fftshift(fft(xd));

% PLOT PILOT AND DATA SPECTRA
n = length(Xd);
fvec = linspace(0,fs/2,n);
figure(4)
plot(fvec,20*log10(abs(Xp)))
hold on
plot(fvec,20*log10(abs(Xd)))
hold off
title('Pilot and data spectra')
xlabel('frequency')
ylabel('dB')
legend('Pilot FFT', 'Data FFT');


% OBTAIN PHASE FOR EACH BIT
Xpa = angle(Xp);
Xda = angle(Xd);
ang = Xda .- Xpa; % compute absolute phase difference between pilot and data Fourier coefficients

Nbits = 2048;

ang = ang(784:end);  % discard first 784 decoded bits (corresponding to nulled subcarriers)
ang = ang(1:Nbits);  % keep only bits that were transmitted

% PLOT DECODED BIT PHASES
figure(5)
plot(ang)
title('demodulate phase vector')
xlabel('bit number')
ylabel('bit phase')


% DETERMINE BIT VALUES BASED ON THRESHOLDS
det = ang;

det(ang <= -pi) = 1;
det((ang > -pi) & (ang <= 0)) = 0;
det((ang > 0) & (ang <= pi)) = 1;
det(ang > pi) = 0;


% PLOT DECODED BITS
figure(6)
plot(det)
title('decoded bits vector')
xlabel('bit number')
ylabel('bit value')


% CONVERT BINARY BACK TO CHARACTERS
bin = det;
det = reshape(det,8,[]);  % reshape decoded bits into array with columns of 8
det = det';  % transpose decoded bit array into rows of 8

Nchar = 256;

charmes = zeros(1,Nchar);  % array to store characters

w = 2.^(7:-1:0);  % powers of 2 to convert binary to decimal

for k = 1:Nchar  % loop over each element of character array
    x = det(k,:);  % extract corresponding row in bit array
    x = sum(x .* w);  % compute decimal value of the character
    charmes(k) = x;  % store to kth element of character array
end


% DISPLAY RESULTS
clc  % clear command window
xstr = char(charmes)  % display decoded message in command window
msgbox(xstr,'replace')  % display decoded message in message box
