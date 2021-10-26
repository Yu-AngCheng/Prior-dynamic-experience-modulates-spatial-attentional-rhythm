function P1 = Myfft(x,window,n,Fs)
 L = length(x);
 x = x .* window;
 Y = fft(x,n);
 P2 = abs(Y/L)';
 P1 = P2(:,1:n/2+1);
 P1(:,2:end-1) = 2*P1(:,2:end-1);
 P1 =  P1.^2;
end