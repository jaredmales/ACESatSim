function Nspt = sptype_numeric(SpT)

type = SpT(1)

if(type == 'O') 
   Nspt = 0; 
end
if(type == 'B') 
   Nspt = 10;
end
if(type == 'A') 
   Nspt = 20; 
end
if(type == 'F') 
   Nspt = 30; 
end
if(type == 'G') 
   Nspt = 40; 
end
if(type == 'K') 
   Nspt = 50; 
end
if(type == 'M') 
   Nspt = 60; 
end
if(type == 'L') 
   Nspt = 70; 
end
if(type == 'T') 
   Nspt = 80; 
end
if(type == 'Y') 
   Nspt = 90;
end


subtype = SpT(2:length(SpT));

Nspt = Nspt + str2num(subtype);


end

