library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_nbitadder is
 
end tb_nbitadder;

architecture structure of tb_nbitadder is 

component nbitadder
generic(N : integer := 32);
   port(i_X0  : in std_logic_vector(N-1 downto 0);
       i_X1  : in std_logic_vector(N-1 downto 0);
       i_Ci  : in std_logic;
       o_Co  : out std_logic;
       o_So  : out std_logic_vector(N-1 downto 0));
end component;

component nbitadderflow
generic(N : integer := 32);
   port(i_X0  : in std_logic_vector(N-1 downto 0);
       i_X1  : in std_logic_vector(N-1 downto 0);
       o_So  : out std_logic_vector(N-1 downto 0));
end component;

signal s_X0,s_X1, s_S1, s_S2  : std_logic_vector(31 downto 0);
signal s_Ci: std_logic;
signal s_Co: std_logic;

begin

adder1 : nbitadder
port map(i_X0  => s_X0,
		i_X1  => s_X1,
		i_Ci  => s_Ci,		
		o_Co  => s_Co,		
		o_So  => s_S1);

adder2 : nbitadderflow
port map(i_X0  => s_X0,
		i_X1  => s_X1,
		o_So  => s_S2);


process
  begin

    s_X0 <= "00000000000000000000000000010000";
    s_X1 <= "00000000000000000000000000000110";
    s_Ci <= '0';
    wait for 100 ns;

    s_X0 <= "00000000010000000000000000000000";
    s_X1 <= "00000000000000000000000000000111";
    s_Ci <= '0';
    wait for 100 ns;


  end process;


end structure;

