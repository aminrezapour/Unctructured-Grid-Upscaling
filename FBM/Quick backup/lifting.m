function f = lifting(cool_mat,A)

    F = cool_mat(:,4);
%     A = sign(A);
    [even_index even_index_dummy]= find(F==1 | F==3);
    [odd_index odd_index_dummy] = find(F==2);
    f_odd = cool_mat(odd_index,3);
    f_even = cool_mat(even_index,3);

    A_tilde = A(:,[odd_index;even_index]');
    A_tilde = A_tilde([odd_index;even_index],:);

    J = A_tilde(1:length(odd_index),length(odd_index)+1:end);
    K = A_tilde(length(odd_index)+1:end,1:length(odd_index));

    D = f_odd - (sum(J,2).^(-1)).*(J*f_even);
    for i = 1:length(D)
       if isnan(D(i))
           D(i) = 0;
       end
    end
    S = f_even + (sum(K,2).^(-1)).*(K*D);
    for i = 1:length(S)
       if isnan(S(i))
           S(i) = f_even(i);
       end
    end
    
%     f_even_hpnn = cool_mat(even_index,[3 4]);
%     [hpnn dum] = find(f_even_hpnn(:,2)==3);
    f = S;
%     f(hpnn) = f_even(hpnn);
    
%     epsilon = sort(abs(D));
%     epsilon = epsilon(floor(length(D)));
%     D_modified = 0*D;
%     D_modified(abs(D) <= epsilon) = 0;
%     f = S - (sum(K,2).^(-1)).*(K*D_modified);
% 
%     for i = 1:length(f)
%        if isnan(f(i))
%            f(i) = S(i);
%        end
%     end
    
end