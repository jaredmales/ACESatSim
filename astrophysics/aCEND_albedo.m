function Ag = aCEND_albedo(bandno, planet)


if planet == 'earth'
   switch bandno
      case 1
         Ag = 0.25*(.3/.2);
      case 2
         Ag = 0.22*(.3/.2);
      case 3
         Ag = 0.2*(.3/.2);
      case 4
         Ag = 0.175*(.3/.2);
      case 5
         Ag = 0.175*(.3/.2);
   end
end


if planet == 'titan'
   switch bandno
      case 1
         Ag = 0.1;
      case 2
         Ag = 0.15;
      case 3
         Ag = 0.18;
      case 4
         Ag = 0.22;
      case 5
         Ag = 0.25;
   end
end


if planet == 'venus'
   switch bandno
      case 1
         Ag = .72;
      case 2
         Ag = 0.8;
      case 3
         Ag = 0.88;
      case 4
         Ag = 0.93;
      case 5
         Ag = 0.94;
   end
end



if planet == 'rmars'
   switch bandno
      case 1
         Ag = 0.05;
      case 2
         Ag = 0.1;
      case 3
         Ag = 0.1;
      case 4
         Ag = 0.35;
      case 5
         Ag = 0.45;
   end
end


