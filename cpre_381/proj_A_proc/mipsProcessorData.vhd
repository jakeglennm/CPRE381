library IEEE;
use IEEE.std_logic_1164.all;

use work.arrayPackage.all;

entity mipsProcessorData is

	port(rs, rt, wd : in std_logic_vector(4 downto 0);
       addOrSub, alus, we, clk, i_exten,wde, muxsel : in std_logic;
	   imm : in std_logic_vector(15 downto 0);
	   read1out, read2out, extendedimm, writedataout : out std_logic_vector(31 downto 0));

end mipsProcessorData;

architecture structure of mipsProcessorData is

component mem is	
	generic (DATA_WIDTH : natural := 32;
		ADDR_WIDTH : natural := 12);
		
	port (clk		: in std_logic;
		addr	        : in std_logic_vector((ADDR_WIDTH-1) downto 0);
		data	        : in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic := '1';
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0));
end component;

component extender is
	port(i_A : in std_logic_vector(15 downto 0);
		i_S : in std_logic;
		o_F : out std_logic_vector(31 downto 0));

end component;

component nMuxStructural is
	generic(N : integer := 32);
	port(i_A : in std_logic_vector(N-1 downto 0);
		i_B : in std_logic_vector(N-1 downto 0);
		i_S : in std_logic;
		o_F : out std_logic_vector(N-1 downto 0));

end component;

component mipsRegister is
	port(readingRS, readingRT, writingRD: in std_logic_vector(4 downto 0);
		writeData : in std_logic_vector(31 downto 0);
		clk, writeEnable : in std_logic;
		readData1, readData2 : out std_logic_vector(31 downto 0));

end component;

component ALUSrc is

	port(addOrSub,ALUSrc : in std_logic;
	   imm,read1,read2 : in std_logic_vector(31 downto 0);
	   result : out std_logic_vector(31 downto 0));

end component;
	
	signal immediate, read1, read2, sum,data_out, write_data  : std_logic_vector(31 downto 0);
	signal address : std_logic_vector(11 downto 0);
begin

	writedataout <= write_data;
	read1out <= read1;
	read2out <= read2;
	extendedimm <= immediate;
	
	G1: for i in 0 to 11 generate
		address(i) <= sum(i);
	end generate;
	
	dmem : mem
	generic map(DATA_WIDTH => 32,
		ADDR_WIDTH => 12)
	port map( clk => clk,
		addr => address,
		data => read1,
		we => wde,
		q => data_out);
	
	
	extend : extender
	port map(i_A => imm,
		i_S => i_exten,
		o_F => immediate);
	
	reg : mipsRegister
	port map(readingRS => rs,
			readingRT => rt,
			writingRD => wd,
			writeData => write_data,
			clk => clk,
			writeEnable => we,
			readData1 => read1,
			readData2 => read2);

	
	al : ALUSrc
	port map(addOrSub => addOrSub,
			ALUSrc => alus,
			imm => immediate,
			read1 => read1,
			read2 => read2,
			result => sum);
    
	mux : nMuxStructural
	port map(i_A => sum,
			i_B => data_out,
			i_S => muxsel,
			o_F => write_data); 
	
end structure;