library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;


entity nbitadderflow is
  generic(N : integer := 32);
  port(i_X0  : in std_logic_vector(N-1 downto 0);
       i_X1  : in std_logic_vector(N-1 downto 0);
       o_So  : out std_logic_vector(N-1 downto 0));

end nbitadderflow;

architecture dataflow of nbitadderflow is 

begin

  o_So <= std_logic_vector(unsigned(i_X0) + unsigned(i_X1));

end dataflow;