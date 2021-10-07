library IEEE;
use IEEE.std_logic_1164.all;

entity tb_2to1mux is
 
end tb_2to1mux;

architecture structure of tb_2to1mux is 

component gen_mux
generic(N : integer := 32);
   port(i_X0  : in std_logic_vector(N-1 downto 0);
       i_X1  : in std_logic_vector(N-1 downto 0);
       i_Sel: in std_logic;
       o_Y  : out std_logic_vector(N-1 downto 0));
end component;

component twoto1muxflow
generic(N : integer := 32);
    port(i_X0  : in std_logic_vector(N-1 downto 0);
       i_X1  : in std_logic_vector(N-1 downto 0);
       i_Sel: in std_logic;
       o_Y  : out std_logic_vector(N-1 downto 0));
end component;

signal s_X0,s_X1, s_Y1, s_Y2  : std_logic_vector(31 downto 0);
signal s_Sel : std_logic;

begin

mux1 : gen_mux
port map(i_X0  => s_X0,
		i_X1  => s_X1, 
		i_Sel => s_Sel, 
  	        o_Y  => s_Y1);

mux2 : twoto1muxflow
port map(i_X0  => s_X0, 
		i_X1  => s_X1,
		i_Sel => s_Sel,
  	        o_Y  => s_Y2);


process
  begin

    s_X0 <= "00000000000000000000000000000000";
    s_X1 <= "11111111111111111111111111111111";
    s_Sel <= '0';
    wait for 100 ns;

    s_X0 <= "00000000000000000000000000000000";
    s_X1 <= "11111111111111111111111111111111";
    s_Sel <= '1';
    wait for 100 ns;


  end process;


end structure;