library IEEE;
use IEEE.std_logic_1164.all;

entity tb_8bitshift is
 
end tb_8bitshift;

architecture structure of tb_8bitshift is 

component eightbitshifter
  port(i_A3  : in std_logic_vector(31 downto 0);
       i_Shamt3: in std_logic;
       i_LorR: in std_logic; -- '0' is left
       i_LogOrAri: in std_logic; --'0' is logical
       o_Y3  : out std_logic_vector(31 downto 0));
end component;

signal s_A3,s_Y3 : std_logic_vector(31 downto 0);
signal s_Shamt3, s_LorR, s_LogOrAri : std_logic;

begin

shifter : eightbitshifter
port map(i_A3  => s_A3,
		  i_Shamt3 => s_Shamt3, 
		  i_LorR => s_LorR, 
		  i_LogOrAri => s_LogOrAri, 
  	        o_Y3  => s_Y3);

process
  begin

    s_A3 <= "10000000100000001000000010000000";
    s_Shamt3 <= '0';
    s_LorR <= '1';
    s_LogOrAri <= '0';
    wait for 100 ns;

    s_A3 <= "10000000100000001000000010000000";
    s_Shamt3 <= '1';
    s_LorR <= '1';
    s_LogOrAri <= '0';
    wait for 100 ns;

    s_A3 <= "10000000100000001000000010000000";
    s_Shamt3 <= '1';
    s_LorR <= '0';
    s_LogOrAri <= '0';
    wait for 100 ns;

    s_A3 <= "10000000100000001000000010000000";
    s_Shamt3 <= '1';
    s_LorR <= '1';
    s_LogOrAri <= '1';
    wait for 100 ns;

    s_A3 <= "10000000100000001000000010000000";
    s_Shamt3 <= '1';
    s_LorR <= '0';
    s_LogOrAri <= '1';
    wait for 100 ns;



  end process;


end structure;