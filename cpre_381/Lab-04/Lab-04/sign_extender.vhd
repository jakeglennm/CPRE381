library IEEE;
use IEEE.std_logic_1164.all;

entity sign_extender is
  port(i_X0  : in std_logic_vector(15 downto 0);
       signOrzero: in std_logic;
       o_Y  : out std_logic_vector(31 downto 0));

end sign_extender;

architecture dataflow of sign_extender is

begin
dff: process (signOrzero,i_X0)
	begin
	if (signOrzero = '1') then
		if(i_X0(15) = '1') then
			o_Y <= "1111111111111111" & i_X0;
		else
			o_Y <= "0000000000000000" & i_X0;
			end if;
else
	o_Y <= "0000000000000000" & i_X0;
	end if;
end process dff;


end dataflow;