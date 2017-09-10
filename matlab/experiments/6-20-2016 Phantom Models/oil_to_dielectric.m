% Paper taken from 
% https://drive.google.com/drive/folders/0B5pEFwbmz3ywaDRaUjBINmVMLWs

% Y Represents the dielectric of the TM material
% x Represents % of oil in Gelatin solution
% f Represents frequency in GHz
function [y] = oil_to_dielectric(x, f)
    a1 = 88.531815;
    b1 = 12525546182.737692;
    c1 = 2.100591;
    
    a = a1/(1+(f/b1)^c1);
    
    a2 = -1.287265;
    b2 = 1.154888e-10;
    c2 = -1.473852e-20;
    d2 = 3.443035e-31;
    e2 = -2.1883193e-42;
    
    b = a2 + b2*f + c2*f^2 + d2*f^3 + e2*f^4;
    
    a3 = -4.376486e-2;
    b3 = 1.769651e-12;
    c3 = -2.255995e-22;
    d3 = 1.418182e-32;
    e3 = -3.824434e-43;
    
    c = a3 + b3*f + c3*f^2 + d3*f^3 + e3*f^4;

    y = a./(1 + exp(b-c*x));

end