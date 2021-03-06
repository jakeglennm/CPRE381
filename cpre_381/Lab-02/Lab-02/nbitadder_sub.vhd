library IEEE;
use IEEE.std_logic_1164.all;

entity nbitadder_sub is
generic(N : integer := 32);
  port(i_X0  : in std_logic_vector(N-1 downto 0);
       i_X1  : in std_logic_vector(N-1 downto 0);
       i_nAdd_Sub : in std_logic;
       i_Ci  : in std_logic;
       o_Co  : out std_logic;
       o_So  : out std_logic_vector(N-1 downto 0));

end nbitadder_sub;

architecture structure of nbitadder_sub is

component adder_sub

port(i_X0  : in std_logic;
       i_X1  : in std_logic;
       i_nAdd_Sub : in std_logic;
       i_Ci  : in std_logic;
       o_Co  : out std_logic;
       o_So  : out std_logic);

end component;

signal carry : std_logic_vector(N downto 0);

begin

carry(0) <= i_nAdd_Sub; 

G1: for i in 0 to N-1 generate
  adder_2: adder_sub
    port map(i_X0  => i_X0(i),
		  i_X1   => i_X1(i),
		 i_nAdd_Sub => i_nAdd_Sub,
		  i_Ci  => carry(i),
		  o_Co  => carry(i+1),
  	          o_So  => o_So(i));

end generate;

o_Co <= carry(N);

end structure;