function simulation_files1(A_T,a,b,c, folder)
    
    A_T_conn = triu(A_T);
    counter = 0;
    fileID = fopen('conn_temp.in','w');
    for i = 1 : length(A_T_conn)
        J = find(A_T_conn(i,:));
        for j = 1 : length(J)
            counter = counter +1;
            fprintf(fileID,'%4d\t %4d\t %f\n',[i-1 J(j)-1 full(A_T_conn(i,J(j)))]);
        end
    end
    fclose(fileID);
    text = fileread('conn_temp.in');
    fileID = fopen(['D:\Dropbox\USC - Amin\matlab\FBM\GPRS\' folder '\conn.in'],'w');
    fprintf(fileID,[num2str(counter) '\n']);
    fprintf(fileID,text);
    fclose(fileID);

    %writing the volume file
    vol = a*b*c*ones(length(A_T),1);
    fileID = fopen(['D:\Dropbox\USC - Amin\matlab\FBM\GPRS\' folder '\volume.in'],'w');
    for i = 1:length(A_T)
        fprintf(fileID,'%f\n',vol(i)); 
    end
    fclose(fileID);
    
end