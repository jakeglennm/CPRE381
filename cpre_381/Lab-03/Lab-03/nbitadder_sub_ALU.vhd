library IEEE;
use IEEE.std_logic_1164.all;

entity nbitadder_sub_ALU is
  port(i_X0  : in std_logic_vector(31 downto 0);
       i_X1  : in std_logic_vector(31 downto 0);
       i_nAdd_Sub : in std_logic;
       i_ALUSrc : in std_logic;
       i_Imm : std_logic_vector(31 downto 0);
       i_Ci  : in std_logic;
       o_Co  : out std_logic;
       o_So  : out std_logic_vector(31 downto 0));

end nbitadder_sub_ALU;

architecture structure of nbitadder_sub_ALU is

component adder_sub_ALU

port(i_X0  : in std_logic;
       i_X1  : in std_logic;
       i_nAdd_Sub : in std_logic;
       i_ALUSrc : in std_logic;
       i_Imm : std_logic;
       i_Ci  : in std_logic;
       o_Co  : out std_logic;
       o_So  : out std_logic);

end component;

signal carry : std_logic_vector(32 downto 0);

begin

carry(0) <= i_nAdd_Sub; 

G1: for i in 0 to 31 generate
  adder_2: adder_sub_ALU
    port map(i_X0  => i_X0(i),
		  i_X1   => i_X1(i),
		 i_nAdd_Sub => i_nAdd_Sub,
		 i_ALUSrc => i_ALUSrc,
		 i_Imm => i_Imm(i),
		  i_Ci  => carry(i),
		  o_Co  => carry(i+1),
  	          o_So  => o_So(i));

end generate;

o_Co <= carry(32);

end structure;