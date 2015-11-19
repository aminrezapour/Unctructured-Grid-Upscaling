function simulation_files_rest(folder,days,nodeN,l,c)

    currentFolder = pwd;
    gprsFolder = '\GPRS\';
    
    text = fileread('control1.in');
    fileID = fopen([currentFolder gprsFolder folder '\control.in'],'w');
    if (fileID == -1)
        fclose(fileID);
        clear fileID;
        mkdir([currentFolder gprsFolder folder]);
        fileID = fopen([currentFolder gprsFolder folder '\control.in'],'w');
    end
    fprintf(fileID,text);
    fprintf(fileID,'\n');
    fprintf(fileID,num2str(days));
    fprintf(fileID,'\n');
    text = fileread('control2.in');
    fprintf(fileID,text);
    fclose(fileID);
    
    text = fileread('gprs.in');
    fileID = fopen([currentFolder gprsFolder folder '\gprs.in'],'w');
    fprintf(fileID,text);
    fclose(fileID);
    
    text = fileread('res_BO_unstruc1.in');
    fileID = fopen([currentFolder gprsFolder folder '\res_BO_unstruc.in'],'w');
    fprintf(fileID,text);
    fprintf(fileID,'\n');
    fprintf(fileID,['GRIDSIZE   ' num2str(nodeN) ' 1 1\n']);
    fprintf(fileID,'DX \n');
    fprintf(fileID,['  ' num2str(l) '\n']);
    fprintf(fileID,'DY \n');
    fprintf(fileID,['  ' num2str(l) '\n']);
    fprintf(fileID,'DZ \n');
    fprintf(fileID,['  ' num2str(c) '\n']);
    text = fileread('res_BO_unstruc2.in');
    fprintf(fileID,text);
    fclose(fileID);
    
    text = fileread('wells_my1.in');
    fileID = fopen([currentFolder gprsFolder folder '\wells_my.in'],'w');
    fprintf(fileID,text);
    fprintf(fileID,'\n');
    fprintf(fileID,[num2str(nodeN-1) '             100 ']);
    fprintf(fileID,'\n');
    text = fileread('wells_my2.in');
    fprintf(fileID,text);
    fclose(fileID);