library IEEE;
use IEEE.std_logic_1164.all;

entity tb_16bitshift is
 
end tb_16bitshift;

architecture structure of tb_16bitshift is 

component sixteenbitshifter
  port(i_A4  : in std_logic_vector(31 downto 0);
       i_Shamt4: in std_logic;
       i_LorR: in std_logic; -- '0' is left
       i_LogOrAri: in std_logic; --'0' is logical
       o_Y4  : out std_logic_vector(31 downto 0));
end component;

signal s_A4,s_Y4 : std_logic_vector(31 downto 0);
signal s_Shamt4, s_LorR, s_LogOrAri : std_logic;

begin

shifter : sixteenbitshifter
port map(i_A4  => s_A4,
		  i_Shamt4 => s_Shamt4, 
		  i_LorR => s_LorR, 
		  i_LogOrAri => s_LogOrAri, 
  	        o_Y4  => s_Y4);

process
  begin

    s_A4 <= "10000000111111111111111100000000";
    s_Shamt4 <= '0';
    s_LorR <= '1';
    s_LogOrAri <= '0';
    wait for 100 ns;

    s_A4 <= "10000000111111111111111100000000";
    s_Shamt4 <= '1';
    s_LorR <= '1';
    s_LogOrAri <= '0';
    wait for 100 ns;

    s_A4 <= "10000000111111111111111100000000";
    s_Shamt4 <= '1';
    s_LorR <= '0';
    s_LogOrAri <= '0';
    wait for 100 ns;

    s_A4 <= "10000000111111111111111100000000";
    s_Shamt4 <= '1';
    s_LorR <= '1';
    s_LogOrAri <= '1';
    wait for 100 ns;

    s_A4 <= "10000000111111111111111100000000";
    s_Shamt4 <= '1';
    s_LorR <= '0';
    s_LogOrAri <= '1';
    wait for 100 ns;



  end process;


end structure;