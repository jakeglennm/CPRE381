library IEEE;
use IEEE.std_logic_1164.all;

entity lui_Unit is
  port(immediate : in std_logic_vector(15 downto 0);
       extended : out std_logic_vector(31 downto 0));
end lui_Unit;

architecture dataflow of lui_Unit is
begin
	
extended <= immediate & "0000000000000000";

end dataflow;