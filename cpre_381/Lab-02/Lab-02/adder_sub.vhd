library IEEE;
use IEEE.std_logic_1164.all;

entity adder_sub is
  port(i_X0  : in std_logic;
       i_X1  : in std_logic;
       i_nAdd_Sub : in std_logic;
       i_Ci  : in std_logic;
       o_Co  : out std_logic;
       o_So  : out std_logic);

end adder_sub;

architecture structure of adder_sub is 

component fulladder
   port(i_X0  : in std_logic;
       i_X1  : in std_logic;
       i_Ci  : in std_logic;
       o_Co  : out std_logic;
       o_So  : out std_logic);
end component;

component twoto1mux
   port(i_X0  : in std_logic;
       i_X1  : in std_logic;
       i_Sel: in std_logic;
       o_Y  : out std_logic);
end component;

component invg
   port(i_A          : in std_logic;
       o_F          : out std_logic);
end component;

signal notA : std_logic;
signal notAorA : std_logic;

begin

invg1 : invg
port map(
	     i_A               => i_X0,
             o_F               => notA);

mux1 : twoto1mux
port map(
	    i_X0	       => i_X0,
	    i_X1	       => notA,
	    i_Sel	       => i_nAdd_Sub,
	    o_Y		       => notAorA);

adder1: fulladder
port map(
	    i_X0	       => notAorA,
	    i_X1	       => i_X1,
	    i_Ci	       => i_Ci,
	    o_Co	       => o_Co,
	    o_So	       => o_So);


end structure;
	    


