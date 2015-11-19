function simulation_files(A_T,V,folder)

    A_T_conn = triu(A_T);
    counter1 = 0;
    
    currentFolder = pwd;
    gprsFolder = '\GPRS\'; % name of the folder you want your gprs files to be in
    
    % conn_temp.in is a temp file to creat a conn.in for GPRS simulator
    fileID = fopen('conn_temp.in','w');
    for i = 1 : length(A_T_conn)
        J = find(A_T_conn(i,:));
        for j = 1 : length(J)
            counter1 = counter1 +1;
            fprintf(fileID,'%4d\t %4d\t %f\n',[i-1 J(j)-1 full(A_T_conn(i,J(j)))]);
        end
    end
    fclose(fileID);
    
    %writing the conn file
    text = fileread('conn_temp.in');
    fileID = fopen([currentFolder gprsFolder folder '\conn.in'],'w');
    if (fileID == -1)
        clear fileID;
        mkdir([currentFolder gprsFolder folder]);
        fileID = fopen([currentFolder gprsFolder folder '\conn.in'],'w');
    end
    fprintf(fileID,[num2str(counter1) '\n']);
    fprintf(fileID,text);
    fclose(fileID);

    %writing the volume file
    fileID = fopen([currentFolder gprsFolder folder '\volume.in'],'w');
    for i = 1:length(V)
        fprintf(fileID,'%f\n',V(i));
    end
    fclose(fileID);

end