function m = noneng(m)

I = find(isnan(m));
m(I) = zeros(1,length(I));
I = find(m <= eps);
m(I) = zeros(1,length(I));
