function rho = get_rho(A, B)
R = corrcoef(A, B);
rho = R(1,2);
end