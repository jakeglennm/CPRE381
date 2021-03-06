library IEEE;
use IEEE.std_logic_1164.all;

use work.vector_type.all;

entity tb_32to1 is

end tb_32to1;

architecture behavior of tb_32to1 is
  
  component mux_32to1
   port(i_Sel	: in std_logic_vector(4 downto 0);
       i_In	: in reg_inputs;
       o_F	: out std_logic_vector(31 downto 0));
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_Sel : std_logic_vector(4 downto 0);
  signal s_F : std_logic_vector(31 downto 0);
  signal inputs: reg_inputs;

begin

  DUT: mux_32to1
  port map(i_Sel => s_Sel, 
           i_In => inputs,
           o_F  => s_F);

 process
   begin

	s_Sel <= "01010";
	inputs(10) <= "10000000000000000000000000000000";
	wait for 100 ns;

	s_Sel <= "00010";
	inputs(2) <= "00000000000000000000000000000010";
	wait for 100 ns;

	s_Sel <= "11111";
	inputs(31) <= "00000000000000000000000000110001";
	wait for 100 ns;


  end process;
  
end behavior;