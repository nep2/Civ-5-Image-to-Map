function mapdrivefunc(m,n)
m=128;
n=58;
A=uint8(imread('northwest','png'));%imports the cover image converts it into 
out=mapmatrix(m,n,A);
%out=flipud(out);
id=fopen('map128x58.civ5map');
map=fread(id);
fin=1319+m*n*8;
for i=1:(m-1)*n
    if out(i)==1
        map(fin-i*8+3)=map(fin-i*8)-1
        map(fin-i*8)=map(fin-i*8)-out(i); 
    else
        map(fin-i*8)=map(fin-i*8)-out(i);
    end
end
scan=fopen('map100x60.civ5map','w');
count=fwrite(scan,map);
st=fclose('all');
end
function outputf=mapmatrix(m,n,A)
%A=uint8(imread(image,type));%imports the cover image converts it into 
%8 bit binary
B=uint8(imread('spiff','jpg'));%imports the hidden image and converts it 
%into 8 bit binary
%2=snow 0=water 10=grassland 5=plains 0=ocean
k=size(A);
output=zeros(k(1),k(2));
for i=1:k(1)
    for j=1:k(2)
        p=A(i,j,:);
        output(i,j);
        if p(1)>220 && p(2)>220 && p(3)>220;
            output(i,j)=2;
        elseif p(2)>130 && p(1)>130 && p(2)<200;
            %output(i,j)=5;
            output(i,j)=3;
        elseif p(1)>170 && p(2)>170 p(3)<200;
        %    output(i,j)=4;
        elseif p(1)+p(2)<p(3)+70% && p(1)+p(2)>p(3)+20
            output(i,j)=0;    
        elseif p(1)<20 && p(2)<20 && p(3)<20
            output(i,j)=1;
        else
            %output(i,j)=10;
            output(i,j)=5;
            %output(i,j)=3;
        end
    end
end
outputf=zeros(m,n);
z=size(output);
for i=1:m
    for j=1:n
        outputf(i,j)=output(floor(z(1)/m*i),floor(z(2)/n*j));
    end
end
end