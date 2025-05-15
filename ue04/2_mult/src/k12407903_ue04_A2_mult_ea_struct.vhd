library IEEE; 
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity mult is 
  port(a:   in STD_ULOGIC_VECTOR(15 downto 0);
       b:   in STD_ULOGIC_VECTOR(15 downto 0);
       y:   out STD_ULOGIC_VECTOR(31 downto 0));
end;

architecture struct of mult is 
  component CRA_GEN is
  generic(
    width : integer
  );
    port(a, b: in  std_ulogic_vector(31 downto 0);
         cin:  in  std_ulogic;
         cout: out std_ulogic;
         sum:  out std_ulogic_vector(31 downto 0)); 
  end component;

  type partial_products_type is array(0 to 15) of std_ulogic_vector(31 downto 0);
  signal partial_products : partial_products_type;
  signal sums : partial_products_type;
  signal carries : std_ulogic_vector(0 to 15);
begin

gen_partial: for i in 0 to 15 generate
  partial_products(i) <= (31 downto 16+i => '0') & 
                        (a and (15 downto 0 => b(i))) & 
                        (i-1 downto 0 => '0');
end generate;

  -- First addition
  first_add: CRA_GEN  generic map(width => 32) port map(
    a => partial_products(0),
    b => partial_products(1),
    cin => '0',
    cout => carries(0),
    sum => sums(0)
  );

  -- Subsequent additions
  gen_adders: for i in 1 to 14 generate
    adder: CRA_GEN GENERIC MAP(width => 32) port map(
      a => sums(i-1),
      b => partial_products(i+1),
      cin => carries(i-1),
      cout => carries(i),
      sum => sums(i));
  end generate;

  -- Final result
  y <= sums(14);
end;