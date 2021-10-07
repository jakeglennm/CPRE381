library IEEE;
use IEEE.std_logic_1164.all;

entity tb_1bitshift is
 
end tb_1bitshift;

architecture structure of tb_1bitshift is 

component onebitshifter
  port(i_A0  : in std_logic_vector(31 downto 0);
       i_Shamt0: in std_logic;
       i_LorR: in std_logic; -- '0' is left
       i_LogOrAri: in std_logic; --'0' is logical
       o_Y0  : out std_logic_vector(31 downto 0));
end component;

signal s_A0,s_Y0  : std_logic_vector(31 downto 0);
signal s_Shamt0, s_LorR, s_LogOrAri : std_logic;

begin

shifter : onebitshifter
port map(i_A0  => s_A0,
		  i_Shamt0 => s_Shamt0, 
		  i_LorR => s_LorR, 
		  i_LogOrAri => s_LogOrAri, 
  	        o_Y0  => s_Y0);

process
  begin

    s_A0 <= "10001000100010001000100010001000";
    s_Shamt0 <= '0';
    s_LorR <= '1';
    s_LogOrAri <= '0';
    wait for 100 ns;

    s_A0 <= "10001000100010001000100010001000";
    s_Shamt0 <= '1';
    s_LorR <= '1';
    s_LogOrAri <= '0';
    wait for 100 ns;

    s_A0 <= "10001000100010001000100010001000";
    s_Shamt0 <= '1';
    s_LorR <= '0';
    s_LogOrAri <= '0';
    wait for 100 ns;

    s_A0 <= "10001000100010001000100010001000";
    s_Shamt0 <= '1';
    s_LorR <= '1';
    s_LogOrAri <= '1';
    wait for 100 ns;

    s_A0 <= "10001000100010001000100010001000";
    s_Shamt0 <= '1';
    s_LorR <= '0';
    s_LogOrAri <= '1';
    wait for 100 ns;



  end process;


end structure;