library IEEE; use IEEE.STD_LOGIC_1164.all;


entity fa is
  port(a, b, cin: in  std_ulogic;
       cout, s:   out std_ulogic);
end;

architecture struct of fa is
begin
    cout <= (a and b) or (a and cin) or (b and cin);
    s <= a xor b xor cin;
end;


entity adder is
  port(a,b: in  std_ulogic_vector(7 downto 0);
       c:   in  std_ulogic;
       s:   out std_ulogic_vector(8 downto 0));
end;

architecture struct of adder is 

  
