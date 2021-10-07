library IEEE;
use IEEE.std_logic_1164.all;

entity mux4 is
	port(i_Sel : in std_logic_vector(3 downto 0);
		i_A,i_B,i_C,i_D,i_E,i_F,i_G,i_H,i_I,i_J,i_K,i_L,i_M,i_N,i_O,i_P : in std_logic;
		o_F : out std_logic);

end mux4;

architecture dataflow of mux4 is

	
begin

	with i_Sel select
		o_F <=  i_A when "0000",
				i_B when "0001",
				i_C when "0010",
				i_D when "0011",
				i_E when "0100",
				i_F when "0101",
				i_G when "0110",
				i_H when "0111",
				i_I when "1000",
				i_J when "1001",
				i_K when "1010",
				i_L when "1011",
				i_M when "1100",
				i_N when "1101",
				i_O when "1110",
				i_P when "1111",
				'0' when others;
		

end dataflow;