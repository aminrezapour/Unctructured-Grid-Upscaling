function date = Calendar_generator(years)
date = zeros(365*years,3);
n=0;
for y = 2010:2010+years
k=1;%Jan
m=0;
for i=1:31
    date(i+m+n,:)=[y k i];
end
k=2;%Feb
m=m+i;
for i=1:28
    date(i+m+n,:)=[y k i];
end
k=3;%Mar
m=m+i;
for i=1:31
    date(i+m+n,:)=[y k i];
end
k=4;%Apr
m=m+i;
for i=1:30
    date(i+m+n,:)=[y k i];
end
k=5;%May
m=m+i;
for i=1:31
    date(i+m+n,:)=[y k i];
end
k=6;%Jun
m=m+i;
for i=1:30
    date(i+m+n,:)=[y k i];
end
k=7;%Jul
m=m+i;
for i=1:31
    date(i+m+n,:)=[y k i];
end
k=8;%Aug
m=m+i;
for i=1:31
    date(i+m+n,:)=[y k i];
end
k=9;
m=m+i;%Sep
for i=1:30
    date(i+m+n,:)=[y k i];
end
k=10;%Oct
m=m+i;
for i=1:31
    date(i+m+n,:)=[y k i];
end
k=11;%Nov
m=m+i;
for i=1:30
    date(i+m+n,:)=[y k i];
end
k=12;%Dec
m=m+i;
for i=1:31
    date(i+m+n,:)=[y k i];
end
n = n+365;
end















