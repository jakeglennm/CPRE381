library IEEE;
use IEEE.std_logic_1164.all;

use work.vector_type.all;

entity reg_file is
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset inputs
       i_WE         : in std_logic;     -- Write enable input(goes into decoder)
       i_WRITE_REG  : in std_logic_vector(4 downto 0);	-- Select line for decoder,output of decoder goes into corresponding register
       i_WRITE_DATA : in std_logic_vector(31 downto 0); -- goes into D of every register
       i_READ_REG1  : in std_logic_vector(4 downto 0); -- goes into first 32:1 mux select line
       i_READ_REG2  : in std_logic_vector(4 downto 0); -- goes into second 32:1 mux select line
       o_READ_DATA1 : out std_logic_vector(31 downto 0); -- output of first 32:1 mux
       o_READ_DATA2 : out std_logic_vector(31 downto 0); -- ouptut of second 32:1 mux
       o_V0	    : out std_logic_vector(31 downto 0));

end reg_file;

architecture structure of reg_file is

component single_reg
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(31 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(31 downto 0));   -- Data value output
end component;

component mux_32to1
   port(i_Sel	: in std_logic_vector(4 downto 0);
       i_In	: in reg_inputs;
       o_F	: out std_logic_vector(31 downto 0));
end component;

component decoder_5to32
  port(i_Sel	: in std_logic_vector(4 downto 0);
       i_En     : in std_logic;
       o_F	: out std_logic_vector(31 downto 0));
end component;

signal reg_values_out : reg_inputs; -- vector_type, could be different declaration
signal decoder_out, global_reset : std_logic_vector(31 downto 0);

begin

decoder : decoder_5to32
  port map(i_Sel  => i_WRITE_REG,
       i_En  => i_WE,
       o_F  => decoder_out);

mux1 : mux_32to1
  port map(i_Sel  => i_READ_REG1,
		  i_In   => reg_values_out,
		  o_F  => o_READ_DATA1);

mux2 : mux_32to1
  port map(i_Sel  => i_READ_REG2,
		  i_In   => reg_values_out,
		  o_F  => o_READ_DATA2);


G1: for i in 0 to 31 generate
  registers: single_reg
    port map(i_CLK  => i_CLK,
		  i_RST   => global_reset(i),
		  i_WE => decoder_out(i),
  	          i_D  => i_WRITE_DATA,
		  o_Q  => reg_values_out(i));

end generate;

o_V0 <= reg_values_out(2);

-- could not get for loop to compile :(
global_reset(0) <= '1';
global_reset(1) <= i_RST;
global_reset(2) <= i_RST;
global_reset(3) <= i_RST;
global_reset(4) <= i_RST;
global_reset(5) <= i_RST;
global_reset(6) <= i_RST;
global_reset(7) <= i_RST;
global_reset(8) <= i_RST;
global_reset(9) <= i_RST;
global_reset(10) <= i_RST;
global_reset(11) <= i_RST;
global_reset(12) <= i_RST;
global_reset(13) <= i_RST;
global_reset(14) <= i_RST;
global_reset(15) <= i_RST;
global_reset(16) <= i_RST;
global_reset(17) <= i_RST;
global_reset(18) <= i_RST;
global_reset(19) <= i_RST;
global_reset(20) <= i_RST;
global_reset(21) <= i_RST;
global_reset(22) <= i_RST;
global_reset(23) <= i_RST;
global_reset(24) <= i_RST;
global_reset(25) <= i_RST;
global_reset(26) <= i_RST;
global_reset(27) <= i_RST;
global_reset(28) <= i_RST;
global_reset(29) <= i_RST;
global_reset(30) <= i_RST;
global_reset(31) <= i_RST;


end structure;
