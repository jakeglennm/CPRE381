library IEEE;
use IEEE.std_logic_1164.all;

entity tb_4bitshift is
 
end tb_4bitshift;

architecture structure of tb_4bitshift is 

component fourbitshifter
  port(i_A2  : in std_logic_vector(31 downto 0);
       i_Shamt2: in std_logic;
       i_LorR: in std_logic; -- '0' is left
       i_LogOrAri: in std_logic; --'0' is logical
       o_Y2  : out std_logic_vector(31 downto 0));
end component;

signal s_A2,s_Y2  : std_logic_vector(31 downto 0);
signal s_Shamt2, s_LorR, s_LogOrAri : std_logic;

begin

shifter : fourbitshifter
port map(i_A2  => s_A2,
		  i_Shamt2 => s_Shamt2, 
		  i_LorR => s_LorR, 
		  i_LogOrAri => s_LogOrAri, 
  	        o_Y2  => s_Y2);

process
  begin

    s_A2 <= "10001000100010001000100010001000";
    s_Shamt2 <= '0';
    s_LorR <= '1';
    s_LogOrAri <= '0';
    wait for 100 ns;

    s_A2 <= "10001000100010001000100010001000";
    s_Shamt2 <= '1';
    s_LorR <= '1';
    s_LogOrAri <= '0';
    wait for 100 ns;

    s_A2 <= "10001000100010001000100010001000";
    s_Shamt2 <= '1';
    s_LorR <= '0';
    s_LogOrAri <= '0';
    wait for 100 ns;

    s_A2 <= "10001000100010001000100010001000";
    s_Shamt2 <= '1';
    s_LorR <= '1';
    s_LogOrAri <= '1';
    wait for 100 ns;

    s_A2 <= "10001000100010001000100010001000";
    s_Shamt2 <= '1';
    s_LorR <= '0';
    s_LogOrAri <= '1';
    wait for 100 ns;



  end process;


end structure;