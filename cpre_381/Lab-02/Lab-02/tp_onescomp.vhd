library IEEE;
use IEEE.std_logic_1164.all;

entity tb_onescomp is
 
end tb_onescomp;

architecture structure of tb_onescomp is 

component onescomp
generic(N : integer := 32);
   port(i_A  : in std_logic_vector(N-1 downto 0);
       o_F  : out std_logic_vector(N-1 downto 0));
end component;

component onescompflow
generic(N : integer := 32);
    port(i_A  : in std_logic_vector(N-1 downto 0);
       o_F  : out std_logic_vector(N-1 downto 0));
end component;

signal s_A, s_F1, s_F2  : std_logic_vector(31 downto 0);

begin

onescomp1 : onescomp
port map(i_A  => s_A, 
  	        o_F  => s_F1);

onescomp2 : onescompflow
port map(i_A  => s_A, 
  	        o_F  => s_F2);


process
  begin

    s_A <= "00000000000000000000000000000000";
    wait for 100 ns;

    s_A <= "11111111111111111111111111111111";
    wait for 100 ns;



  end process;


end structure;