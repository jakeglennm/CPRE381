library IEEE;
use IEEE.std_logic_1164.all;

entity tb_signextend is
 
end tb_signextend;

architecture structure of tb_signextend is 

component sign_extender
  port(i_X0  : in std_logic_vector(15 downto 0);
       signOrzero: in std_logic;
       o_Y  : out std_logic_vector(31 downto 0));
end component;

signal s_Y  : std_logic_vector(31 downto 0);
signal s_signOrzero : std_logic;
signal input : std_logic_vector(15 downto 0);

begin

extender : sign_extender
port map(i_X0  => input,
		  signOrzero => s_signOrzero, 
  	        o_Y  => s_Y);

process
  begin

    input <= "0000000000000000";
    s_signOrzero <= '0';
    wait for 100 ns;

    input <= "1111111111111111";
    s_signOrzero <= '1';
    wait for 100 ns;

    input <= "0000000000001111";
    s_signOrzero <= '0';
    wait for 100 ns;

    input <= "0111110000000000";
    s_signOrzero <= '1';
    wait for 100 ns;



  end process;


end structure;