library IEEE;
use IEEE.std_logic_1164.all;

entity single_reg is
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(31 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(31 downto 0));   -- Data value output
end single_reg;

architecture structure of single_reg is

component dff
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output
end component;

begin

G1: for i in 0 to 31 generate
  reg_i: dff
    port map(i_CLK  => i_CLK,
		  i_RST   => i_RST,
		  i_WE => i_WE,
  	          i_D  => i_D(i),
		  o_Q  => o_Q(i));

end generate;

  
end structure;