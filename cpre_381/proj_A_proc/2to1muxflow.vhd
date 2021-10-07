library IEEE;
use IEEE.std_logic_1164.all;

entity twoto1muxflow is
  port(i_X0  : in std_logic_vector(31 downto 0);
       i_X1  : in std_logic_vector(31 downto 0);
       i_Sel: in std_logic;
       o_Y  : out std_logic_vector(31 downto 0));

end twoto1muxflow;

architecture dataflow of twoto1muxflow is

begin

G1: for i in 0 to 31 generate
  o_Y(i) <= (((not i_Sel) and i_X0(i)) or (i_Sel and i_X1(i)));
 end generate;

end dataflow;