function [Xmag, Xpha, faxis] = getFFT(x, Fs)
N = length(x);
temp = fft(x,N)/N;
Xmag = abs(temp);
Xpha = angle(temp);
faxis = (Fs/N)*(0:N-1);
end