library IEEE;
use IEEE.std_logic_1164.all;

entity tb_2bitshift is
 
end tb_2bitshift;

architecture structure of tb_2bitshift is 

component twobitshifter
  port(i_A1  : in std_logic_vector(31 downto 0);
       i_Shamt1: in std_logic;
       i_LorR: in std_logic; -- '0' is left
       i_LogOrAri: in std_logic; --'0' is logical
       o_Y1  : out std_logic_vector(31 downto 0));
end component;

signal s_A1,s_Y1  : std_logic_vector(31 downto 0);
signal s_Shamt1, s_LorR, s_LogOrAri : std_logic;

begin

shifter : twobitshifter
port map(i_A1  => s_A1,
		  i_Shamt1 => s_Shamt1, 
		  i_LorR => s_LorR, 
		  i_LogOrAri => s_LogOrAri, 
  	        o_Y1  => s_Y1);

process
  begin

    s_A1 <= "00100010001000100010001000100010";
    s_Shamt1 <= '0';
    s_LorR <= '1';
    s_LogOrAri <= '0';
    wait for 100 ns;

    s_A1 <= "00100010001000100010001000100010";
    s_Shamt1 <= '1';
    s_LorR <= '1';
    s_LogOrAri <= '0';
    wait for 100 ns;

    s_A1 <= "00100010001000100010001000100010";
    s_Shamt1 <= '1';
    s_LorR <= '0';
    s_LogOrAri <= '0';
    wait for 100 ns;

    s_A1 <= "00100010001000100010001000100010";
    s_Shamt1 <= '1';
    s_LorR <= '1';
    s_LogOrAri <= '1';
    wait for 100 ns;

    s_A1 <= "00100010001000100010001000100010";
    s_Shamt1 <= '1';
    s_LorR <= '0';
    s_LogOrAri <= '1';
    wait for 100 ns;



  end process;


end structure;