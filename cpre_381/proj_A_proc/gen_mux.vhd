library IEEE;
use IEEE.std_logic_1164.all;

entity gen_mux is
  generic(N : integer := 5);
  port(i_X0  : in std_logic_vector(N-1 downto 0);
       i_X1  : in std_logic_vector(N-1 downto 0);
       i_Sel: in std_logic;
       o_Y  : out std_logic_vector(N-1 downto 0));

end gen_mux;

architecture structure of gen_mux is

component twoto1mux
  port(i_X0  : in std_logic;
       i_X1  : in std_logic;
       i_Sel: in std_logic;
       o_Y  : out std_logic);
end component;

begin

G1: for i in 0 to N-1 generate
  mux_i: twoto1mux
    port map(i_X0  => i_X0(i),
		  i_X1   => i_X1(i),
		  i_Sel  => i_Sel,
  	          o_Y  => o_Y(i));

end generate;

  
end structure;