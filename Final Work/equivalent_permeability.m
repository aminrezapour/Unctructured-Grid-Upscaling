function k = equivalent_permeability(a_0,k_0,areas)
   
    num = size(areas,1) + 1;
    
    A = a_0 + sum(areas(:,1));
    coeffs = [a_0;areas(:,1)]/A;    
    K = [k_0;areas(:,2)]/1000;
    C = [];
    
    for i = 1 : num
        temp = K;
        temp(i) = [];
        c = [-1 K(i)];
        for j = 1 : num - 1
            c = conv(c,[1 temp(j)]);
        end
        C = [C;c];
    end
    
    pol = kron(coeffs,ones(1,size(C,2))).*C;
    pol = sum(pol);
    
    k_all = roots(pol)*1000;
    k_mean = sum(K.*coeffs)*1000;
    k_harm = 1000/sum((K.^(-1)).*coeffs);
    
    k_s = k_all(k_all>=k_harm);
    k_s = k_s(k_s<=k_mean);
    
    if length(k_s)==1
        k = k_s;
    elseif size(k_s,1)<1
        k_a = abs(k_all-k_harm);
        k_b = abs(k_all-k_mean);
        if min(k_a)<min(k_b)
            k = k_harm;
        else k = k_mean;
        end
    else k = mean(k_s);
    end
    
end

