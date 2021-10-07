library IEEE;
use IEEE.std_logic_1164.all;

entity adder_sub_ALU is
  port(i_X0  : in std_logic;
       i_X1  : in std_logic;
       i_nAdd_Sub : in std_logic;
       i_ALUSrc : in std_logic;
       i_Imm : std_logic;
       i_Ci  : in std_logic;
       o_Co  : out std_logic;
       o_So  : out std_logic);

end adder_sub_ALU;

architecture structure of adder_sub_ALU is 

component fulladder
   port(i_A  : in std_logic;
       i_B  : in std_logic;
       i_C  : in std_logic;
       o_C  : out std_logic;
       o_S  : out std_logic);
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

signal notB : std_logic;
signal notBorB : std_logic;
signal immORB : std_logic;

begin


mux2 : twoto1mux
port map(
	    i_X0	       => i_X1,
	    i_X1	       => i_Imm,
	    i_Sel	       => i_ALUSrc,
	    o_Y		       => immORB);

invg1 : invg
port map(
	     i_A               => immORB,
             o_F               => notB);

mux1 : twoto1mux
port map(
	    i_X0	       => immORB,
	    i_X1	       => notB,
	    i_Sel	       => i_nAdd_Sub,
	    o_Y		       => notBorB);

adder1: fulladder
port map(
	    i_A	       => notBorB,
	    i_B	       => i_X0,
	    i_C	       => i_Ci,
	    o_C	       => o_Co,
	    o_S        => o_So);


end structure;
	    

