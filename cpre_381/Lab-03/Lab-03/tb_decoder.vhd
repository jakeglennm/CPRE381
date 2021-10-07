library IEEE;
use IEEE.std_logic_1164.all;

entity tb_decoder is

end tb_decoder;

architecture behavior of tb_decoder is
  
  component decoder_5to32
  port(i_Sel	: in std_logic_vector(4 downto 0);
       i_En     : in std_logic;
       o_F	: out std_logic_vector(31 downto 0));
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_En  : std_logic;
  signal s_Sel : std_logic_vector(4 downto 0);
  signal s_F : std_logic_vector(31 downto 0);

begin

  DUT: decoder_5to32
  port map(i_Sel => s_Sel, 
           i_En => s_En,
           o_F  => s_F);

 process
   begin

	s_Sel <= "00011";
	s_En <= '1';
	wait for 100 ns;

	s_Sel <= "00100";
	s_En <= '1';
	wait for 100 ns;

	s_Sel <= "11111";
	s_En <= '0';
	wait for 100 ns;

	s_Sel <= "00000";
	s_En <= '0';
	wait for 100 ns;

	s_Sel <= "00000";
	s_En <= '1';
	wait for 100 ns;

	s_Sel <= "11111";
	s_En <= '1';
	wait for 100 ns;


  end process;
  
end behavior;