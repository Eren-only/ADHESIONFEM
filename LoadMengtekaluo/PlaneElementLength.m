function length = PlaneElementLength(x1,x2,i)
%PlaneFrameElementLength This function returns the length of the
% plane frame element whose first node has
% coordinates (x1,y1) and second node has
% coordinates (x2,y2).
length = x2 - x1;
if(length <= 1e-5)
     lengthtest="lengthError.txt";
     lengthread = fopen(lengthtest,'a+');
     fprintf( lengthread,'%g\t',i);
     fprintf( lengthread,'%g\t',x2);
     fprintf( lengthread,'%g\t',x1);
     fprintf(lengthread,'\r\n');
     fclose( lengthread); 
end
end

