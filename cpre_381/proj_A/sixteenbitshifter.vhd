library IEEE;
use IEEE.std_logic_1164.all;

entity sixteenbitshifter is
  port(i_A4  : in std_logic_vector(31 downto 0);
       i_Shamt4: in std_logic;
       i_LorR: in std_logic; -- '0' is left
       i_LogOrAri: in std_logic; --'0' is logical
       o_Y4  : out std_logic_vector(31 downto 0));

end sixteenbitshifter;

architecture structure of sixteenbitshifter is

component twoto1mux
  port(i_X0  : in std_logic;
       i_X1  : in std_logic;
       i_Sel: in std_logic;
       o_Y  : out std_logic);
end component;

-- signals go here
signal inputs  : std_logic_vector(31 downto 0);
signal sign_bit : std_logic;
 
begin 

sign_bit <= i_A4(31);

proc: process (i_LorR,i_A4, i_LogOrAri,sign_bit,inputs)
	begin
	if (i_LorR = '0') then 
		if(i_LogOrAri = '0') then --shift left logical
			loop_1a:for k in 0 to 15 loop
				inputs(k)<= '0';
			end loop;
			loop_1b: for k in 16 to 31 loop
				inputs(k)<= i_A4(k-16);
			end loop;
		else --shift left arithmetic(same as logical)
			loop_2a:for k in 0 to 15 loop
				inputs(k)<= '0';
			end loop;
			loop_2b: for k in 16 to 31 loop
				inputs(k)<= i_A4(k-16);
			end loop;
			end if;
       else  --(i_LorR = '1')
		if(i_LogOrAri = '0') then --shift right logical
			loop_3a: for k in 0 to 15 loop
				inputs(k)<= i_A4(k+16);
			end loop;
			loop_3b: for k in 16 to 31 loop
				inputs(k)<= '0';
			end loop;
		else --shift right arithmetic
			loop_4a: for k in 16 to 31 loop
				inputs(k)<= sign_bit;
			end loop;
			loop_4b: for k in 0 to 15 loop
				inputs(k)<= i_A4(k+16);
			end loop;
			
			end if;
	end if;
end process proc;

G1: for i in 0 to 31 generate 
  mux_i: twoto1mux
    port map(i_X0  => i_A4(i),
		  i_X1   => inputs(i),
		  i_Sel  => i_Shamt4,
  	          o_Y  => o_Y4(i));
end generate;

end structure;