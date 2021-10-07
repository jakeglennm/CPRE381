library IEEE;
use IEEE.std_logic_1164.all;

entity alu32 is
    port(i_A, i_B : in std_logic_vector(31 downto 0);
	   i_Control : in std_logic_vector(3 downto 0);
       o_F : out std_logic_vector(31 downto 0);
	   o_Carry,o_Overflow,o_Zero : out std_logic);

end alu32;

architecture structure of alu32 is

component notOrg32
  port(i_A          : in std_logic_vector(31 downto 0);
       o_F          : out std_logic);
end component;

component mux4
	port(i_Sel : in std_logic_vector(3 downto 0);
		i_A,i_B,i_C,i_D,i_E,i_F,i_G,i_H,i_I,i_J,i_K,i_L,i_M,i_N,i_O,i_P : in std_logic;
		o_F : out std_logic);

end component;

component singleALU
    port(i_A : in std_logic;
       i_B : in std_logic;
	   i_Carry : in std_logic;
	   i_Less : in std_logic;
	   i_Select : in std_logic_vector(3 downto 0);
       o_R : out std_logic;
	   o_Carry : out std_logic);
end component;

component specialALU
    port(i_A : in std_logic;
       i_B : in std_logic;
	   i_Carry : in std_logic;
	   i_Less : in std_logic;
	   i_Select : in std_logic_vector(3 downto 0);
       o_R : out std_logic;
	   o_Carry : out std_logic;
	   o_Set : out std_logic;
	   o_Overflow : out std_logic);
end component;

signal set, less ,carry_in: std_logic;
signal output : std_logic_vector(31 downto 0);
signal carry : std_logic_vector(31 downto 0);

begin
	mux_1 :mux4
	port map(i_Sel => i_Control,
			i_A => '0',
			i_B => '1',
			i_C => '0',
			i_D => '1',
			i_E => '0',
			i_F => '0',
			i_G => '0',
			i_H => '0',
			i_I => '0',
			i_J => '0',
			i_K => '0',
			i_L => '0',
			i_M => '0',
			i_N => '0',
			i_O => '0',
			i_P => '0',
			o_F => carry_in);
	
	singleALU_0 : singleALU
	port map(i_A => i_A(0),
			i_B => i_B(0),
			i_Carry => carry_in,
			i_Less => set,
			i_Select => i_Control,
			o_R => output(0),
			o_Carry => carry(0));
			
	G1: for i in 1 to 30 generate
	singleALU_i : singleALU
	port map(i_A => i_A(i),
			i_B => i_B(i),
			i_Carry => carry(i-1),
			i_Less => '0',
			i_Select => i_Control,
			o_R => output(i),
			o_Carry => carry(i));
	end generate;
	
	specialALU_0 : specialALU
	port map(i_A => i_A(31),
			i_B => i_B(31),
			i_Carry => carry(30),
			i_Less => '0',
			i_Select => i_Control,
			o_R => output(31),
			o_Carry => carry(31),
			o_Set => set,
			o_Overflow => o_Overflow);
	
	o_Carry <= carry(31);
	
	less <= set;
	
	zeroCalculater : notOrg32
	port map(i_A => output,
			o_F => o_Zero);
	
	o_F <= output;

end structure;