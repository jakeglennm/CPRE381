library IEEE;
use IEEE.std_logic_1164.all;

entity tb_barrelshift is
 
end tb_barrelshift;

architecture structure of tb_barrelshift is 

component barrelshifter
  port(i_A  : in std_logic_vector(31 downto 0);
       i_Shamt: in std_logic_vector(4 downto 0);
       i_LorR: in std_logic; -- '0' is left
       i_LogOrAri: in std_logic; --'0' is logical
       o_Y  : out std_logic_vector(31 downto 0));
end component;

signal s_A,s_Y : std_logic_vector(31 downto 0);
signal s_Shamt : std_logic_vector(4 downto 0);
signal s_LorR, s_LogOrAri : std_logic;

begin

shifter : barrelshifter
port map(i_A  => s_A,
		  i_Shamt => s_Shamt, 
		  i_LorR => s_LorR, 
		  i_LogOrAri => s_LogOrAri, 
  	        o_Y  => s_Y);

process
  begin

    s_A <= "10000000000000000000000000000000";
    s_Shamt <= "00000";
    s_LorR <= '1';
    s_LogOrAri <= '1';
    wait for 100 ns;

    s_A <= "10000000000000000000000000000000";
    s_Shamt <= "11111";
    s_LorR <= '1';
    s_LogOrAri <= '0';
    wait for 100 ns;

    s_A <= "10000000000000000000000000000000";
    s_Shamt <= "11111";
    s_LorR <= '1';
    s_LogOrAri <= '1';
    wait for 100 ns;

    s_A <= "11111110000000000000000001111111";
    s_Shamt <= "00111";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    wait for 100 ns;

    s_A <= "11111110000000000000000001111111";
    s_Shamt <= "00111";
    s_LorR <= '0';
    s_LogOrAri <= '1';
    wait for 100 ns;

    s_A <= "11111110000000000000000001111111";
    s_Shamt <= "00111";
    s_LorR <= '1';
    s_LogOrAri <= '0';
    wait for 100 ns;

    s_A <= "11111110000000000000000001111111";
    s_Shamt <= "00111";
    s_LorR <= '1';
    s_LogOrAri <= '1';
    wait for 100 ns;

    s_A <= "11110000000000000000000000001111";
    s_Shamt <= "01111";
    s_LorR <= '1';
    s_LogOrAri <= '1';
    wait for 100 ns;

    s_A <= "11110000000000000000000000001111";
    s_Shamt <= "01111";
    s_LorR <= '1';
    s_LogOrAri <= '0';
    wait for 100 ns;

    s_A <= "11110000000000000000000000001111";
    s_Shamt <= "01111";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    wait for 100 ns;

  end process;


end structure;