function mapdrivefunc(m,n)
m=80;%These are the dimensions of the map. M is length n is height
n=80;
A=uint8(imread('rplace','png'));%imports the image and converts it into
%binary
out=mapmatrix(m,n,A);%calls the 2nd function to get the m x n matrix of 
%terrain from the image
%out=flipud(out);%this flips the map 180 degrees. uncomment to flip map
id=fopen('map80x80.civ5map');%opens a map file to edit. This file must be 
%a m by n civ 5 map of all ocean tiles, created in the sdk. If it is not a
%m by n map the output map will be distorted, and if it is not all ocean
%the output terrain will be wrong
map=fread(id);%reads the data from the empty map and turns it into a vector
fin=1319+m*n*8;%this is the index of the info for the last tile in the map 
%vector. Matlab and the sdk write index info in different orders so I went
%from switched the order to help this. The final map will be rotated 90
%degrees which I could not fix. I recomend rotating the original 
%image 90 degrees to the left so the final map is not misoriented
for i=1:m*n
        map(fin-i*8)=map(fin-i*8)-out(i);%this converts the ocean tiles 
        %the terrain specified in the function mapmatrix
end
scan=fopen('map100x60.civ5map','w');%opens a file to put the new map in
count=fwrite(scan,map);%writes the map into the new file
st=fclose('all');%closes all files
end
function outputf=mapmatrix(m,n,A)
%2=snow 0=water 10=grassland 5=plains 0=ocean 4=desert
k=size(A);
output=zeros(k(1),k(2));
for i=1:k(1)%this loops for every pixel in the image and determines the 
    %terrain that corresponds to the color. Checking every pixel is not
    %necessary, but i'm to lazy to change the code. The code would run
    %quicker if only m*n pixels were checked, but it doesnt take very long
    %as is
    for j=1:k(2)
        p=A(i,j,:);
        output(i,j);
        if p(1)>220 && p(2)>220 && p(3)>220;%this is my definition of white
 %I have issues with distinguishing between snow and desert (both are
 %whiteish) so I recommend commenting out either the snow line or the
 %desert line depending on the map you are trying to make
            output(i,j)=2;
        elseif p(2)>130 && p(1)>130 && p(2)<200;%this is my defintion of 
 %plains or tundra. comment out the 5 line for tundra. comment out the 3
 %for plains
            output(i,j)=5;
            %output(i,j)=3;
        elseif p(1)>170 && p(2)>170 p(3)<200;%this is my definition of 
 %desert often conflicts with snow
        %    output(i,j)=4;
        elseif p(1)+p(2)<p(3)+70% && p(1)+p(2)>p(3)+20 this is my definiton 
 % of ocean
            output(i,j)=0;    
        elseif p(1)<20 && p(2)<20 && p(3)<20
            output(i,j)=1;
        else
            %output(i,j)=10;
            output(i,j)=10;
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