library IEEE;
use IEEE.std_logic_1164.all;

entity projA_alu is
  port(i_A,i_B  : in std_logic_vector(31 downto 0);
       i_Shamt: in std_logic_vector(4 downto 0);
       i_Control: in std_logic_vector(3 downto 0);
       i_LorR: in std_logic; -- '0' is left
       i_LogOrAri: in std_logic; --'0' is logical
       i_shiftOrnot : in std_logic; --named this way to be clear
       o_F  : out std_logic_vector(31 downto 0);
       o_Carry,o_Overflow,o_Zero : out std_logic);

end projA_alu;

architecture structure of projA_alu is

component barrelshifter
  port(i_A  : in std_logic_vector(31 downto 0);
       i_Shamt: in std_logic_vector(4 downto 0);
       i_LorR: in std_logic; -- '0' is left
       i_LogOrAri: in std_logic; --'0' is logical
       o_Y  : out std_logic_vector(31 downto 0));
end component;

component alu32
  port(i_A,i_B  : in std_logic_vector(31 downto 0);
       i_Control: in std_logic_vector(3 downto 0);
       o_Carry,o_Overflow,o_Zero : out std_logic;
       o_F : out std_logic_vector(31 downto 0));
end component;

component twoto1muxflow 
  port(i_X0  : in std_logic_vector(31 downto 0);
       i_X1  : in std_logic_vector(31 downto 0);
       i_Sel: in std_logic;
       o_Y  : out std_logic_vector(31 downto 0));
end component;

signal o_alu, o_shift, output : std_logic_vector(31 downto 0);

begin

alu: alu32
    port map(i_A  => i_A,
		  i_B   => i_B,
		  i_Control  => i_Control,
		  o_Carry => o_Carry,
		  o_Overflow => o_Overflow,
		  o_Zero => o_Zero,
  	          o_F  => o_alu);

shifter: barrelshifter
    port map(i_A  => i_B,
		  i_Shamt   => i_Shamt,
		  i_LorR  => i_LorR,
		  i_LogOrAri => i_LogOrAri,
  	          o_Y  => o_shift);

mux : twoto1muxflow
    port map(i_X0  => o_alu,
		  i_X1   => o_shift,
		  i_Sel  => i_shiftOrnot,
  	          o_Y  => output);

o_F <= output;

end structure;