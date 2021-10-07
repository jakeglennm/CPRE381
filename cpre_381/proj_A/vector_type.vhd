library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package vector_type is
    type reg_inputs is array(31 downto 0) of std_logic_vector(31 downto 0);
end package vector_type;