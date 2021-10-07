library IEEE;
use IEEE.std_logic_1164.all;

entity specialALU is
    port(i_A : in std_logic;
       i_B : in std_logic;
	   i_Carry: in std_logic;
	   i_Less : in std_logic;
	   i_Select : in std_logic_vector(3 downto 0);
       o_R : out std_logic;
	   o_Carry : out std_logic;
	   o_Set : out std_logic;
	   o_Overflow : out std_logic);

end specialALU;

architecture structure of specialALU is

component fullAdder
    port(i_A : in std_logic;
       i_B : in std_logic;
	   i_C : in std_logic;
       o_S : out std_logic;
	   o_C : out std_logic);
end component;

component mux4
	port(i_Sel : in std_logic_vector(3 downto 0);
		i_A,i_B,i_C,i_D,i_E,i_F,i_G,i_H,i_I,i_J,i_K,i_L,i_M,i_N,i_O,i_P : in std_logic;
		o_F : out std_logic);

end component;

component xorg2
	port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

component org2
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

component andg2
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

signal notA, outR, BsubA,BcarryA, overflow, carry_out, AorB,AandB,AnandB, AnorB, AadduB, AsubuB, AaddB, AsubB , AxorB, notB, addC, subC: std_logic;


begin
	AnorB <= not AorB;
	AnandB <= not AandB;
	AadduB <= AaddB;
	AsubuB <= AsubB;
	notB <= not i_B;
	notA <= not i_A;
	
	fullAdder_0: fullAdder
	port map(i_A => i_A,
			i_B => i_B,
			i_C => i_Carry,
			o_S => AaddB,
			o_C =>addC);

	fullAdder_1: fullAdder
	port map(i_A => i_A,
			i_B => notB,
			i_C => i_Carry,
			o_S => AsubB,
			o_C => subC);
	
	fullAdder_2: fullAdder
	port map(i_A => i_B,
			i_B => notA,
			i_C => i_Carry,
			o_S => BsubA,
			o_C => BcarryA);
	
	xorg_0: xorg2
	port map(i_A => i_A,
			i_B => i_B,
			o_F => AxorB);
	
	and_0: andg2
	port map(i_A => i_A,
			i_B => i_B,
			o_F => AandB);

	or_0: org2
	port map(i_A => i_A,
			i_B => i_B,
			o_F => AorB);
	
	mux_0 : mux4
	port map(i_Sel => i_Select,
			i_A => AaddB,
			i_B => AsubB,
			i_C => AadduB,
			i_D => AsubuB,
			i_E => i_Less,
			i_F => AandB,
			i_G => AorB,
			i_H => AxorB,
			i_I => AnandB,
			i_J => AnorB,
			i_K => '0',
			i_L => '0',
			i_M => '0',
			i_N => '0',
			i_O => '0',
			i_P => '0',
			o_F => outR);
	
	mux_2 :mux4
	port map(i_Sel => i_Select,
			i_A => addC,
			i_B => subC,
			i_C => addC,
			i_D => subC,
			i_E => subC,
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
			o_F => carry_out);
	
	o_Carry <= carry_out;
	o_R <= outR;
	
	xorg_1: xorg2
	port map(i_A => carry_out,
			i_B => i_Carry,
			o_F => overflow);
	
	o_Overflow <= overflow;
	o_Set <= AsubB;
	--o_Set <= carry_out or overflow;

end structure;
