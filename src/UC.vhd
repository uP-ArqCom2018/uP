library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UC is
	generic(
		opcode	:	integer	:=	32
	);
	port(
		INSTR_i	:	in		std_logic_vector(opcode-1 downto 0);				-- instruccion de entrada
		Condbranch_o		:	out	std_logic;										-- salto
		Ucondbranch_o	:	out	std_logic;										-- salto incondicional
		MemRead_o	:	out	std_logic;										-- lectura de memoria
		MemtoReg_o	:	out	std_logic;										-- memoria a registro
		ALUop_o		:	out	std_logic_vector(3 downto 0);				-- seleccion de operacion de ALU
		MemWrite_o	:	out	std_logic;										-- escritura de memoria
		ALUsrc_o		:	out	std_logic;										-- selecciona entre un inmediato y un registro
		Reg_W_o	:	out	std_logic);										-- escritura de registro
	
end UC;

architecture control_arch of UC is
	signal opcode_i:	std_logic_vector(6 downto 0); 	--opcode de instruccion, hasta 7 bits
	signal func3: 		std_logic_vector(2 downto 0);   -- func3 de instruccion, hasa 3 bits 
	signal func7: 		std_logic_vector(6 downto 0); 	-- func7 de instruccion, hasta 7 bits 
	begin
	opcode_i <= INSTR_i(6 downto 0);      -- se le otorga la parte que corresponde al opcode
	func3 <= INSTR_i(14 downto 12);		  -- se le ortorga la parte que corresponde a func3
	func7 <= INSTR_i (31 downto 25);      -- se le otorga la parte qu corresponde a func7 	
	Condbranch_o		<= '1' when (opcode_i = "1100111") else '0';
	Ucondbranch_o	<= '1' when (opcode_i= "1100011" or opcode_i="1101111") else '0';
	MemRead_o	<= '1' when (opcode_i = "0000011") else '0';
	MemtoReg_o	<= '1' when (opcode_i = "0000011") else '0';
	MemWrite_o	<= '1' when (opcode_i = "0100011" ) else '0';
	ALUsrc_o		<= '1' when (opcode_i="0000011" or opcode_i = "0010011" or opcode_i= "0100011") else '0'; -- verificar jalr y jal 
	Reg_W_o	<= '1' when (opcode_i="0110011" or opcode_i="0000011" or opcode_i= "0010011") else '0';
	
		-- ALUop_o -------------
	-- 0000 ADD (instrucciones= add, addi, ldur, stur)
	-- 0001 SUB (sub, subs)
	-- 0011 AND (and, andi)
	-- 0100 OR  (or, orri)
	-- 0101 XOR (xor, xori)
	-- 0110 SRL
	-- 0111 SRA Y SLL 
			
	ALUop_o <= 		"0000" when ((opcode_i = "0110011" and func3="000" and func7="0000000") or (opcode_i= "0000011") or (opcode_i="0010011" and func3="000") or (opcode_i="0100011") )else
					"0001" when ((opcode_i = "0110011" and func7="0100000") or (opcode_i="1100111")) else
					"0111" when ((opcode_i = "0110011" and func3="001") or(opcode_i = "0110011" and func3="101") or (opcode_i="0010011" and func3= "001") or (opcode_i= "0010011" and func3= "101" and func7="0100000"))else
					"0101" when ((opcode_i = "0110011" and func3="100") or (opcode_i="0010011" and func3="100"))else
					"0110" when ((opcode_i = "0110011" and func3="101") or (opcode_i="0010011" and func3="101" and func7="0000000")) else
					"0100" when ((opcode_i = "0110011" and func3="110") or (opcode_i="0010011" and func3="110")) else
					"0011" ;							
end control_arch;