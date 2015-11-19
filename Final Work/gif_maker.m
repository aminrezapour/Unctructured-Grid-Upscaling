load final_work_300.mat

figure(1);
filename = 'pruning.gif';

for i = 1:16
    drawImage(cool_mat{i}(:,1:3),l);
    drawnow
    frame = getframe(1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if i == 1;
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append');
    end
end