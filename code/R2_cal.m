function R2 = R2_cal(y, y_hat)
y_bar = mean(y);
num = sum((y-y_hat).^2);
den = sum((y-y_bar).^2);
R2 = (1-(num/den))*100;
end