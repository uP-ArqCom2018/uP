library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ALU is

    generic (N : integer :=64);
		  
    port (
        A_i      : in  std_logic_vector(N - 1 downto 0);
        B_i      : in  std_logic_vector(N - 1 downto 0);
        SAL_o    : out std_logic_vector(N - 1 downto 0);
	    ALUop_i  : in  std_logic_vector(3 downto 0);
	    Zero_o   : out std_logic
        );
end entity;

architecture implementacion of ALU is

	--constantes de opcode:
--	CONSTANT ADD    : unsigned(3 downto 0) := "0000";
--	CONSTANT SUB    : unsigned(3 downto 0) := "0001";
--	CONSTANT NOT_IN : unsigned(3 downto 0) := "0010";
--	CONSTANT AND_IN : unsigned(3 downto 0) := "0011";
--	CONSTANT OR_IN  : unsigned(3 downto 0) := "0100";
--	CONSTANT XOR_IN : unsigned(3 downto 0) := "0101";
--	CONSTANT SRL_IN : unsigned(3 downto 0) := "0110";
--	CONSTANT SLL_IN : unsigned(3 downto 0) := "0111";
--	CONSTANT SRA_IN : unsigned(3 downto 0) := "1000";   
          
	SIGNAL senial_aux_sal : std_logic_vector(N-1 downto 0);
	-- SIGNAL senial_aux_SRA : std_logic_vector(N-1 downto 0); -- Señal auxiliar para realizar el desplazamiento aritmetico
	
	
	begin


-- Se analiza el flag Z

SAL_o <= senial_aux_sal;

Zero_o <= '1' when senial_aux_sal = std_logic_vector(to_unsigned(0,N)) else '0'; 

process(A_i, B_i, ALUop_i)
	VARIABLE aux1 : std_logic;  -- variable para SRA
	VARIABLE aux2 : std_logic_vector(N-1 downto 0);
	
		begin

		case ALUop_i is
		
					when "0000" =>
						senial_aux_sal <= std_logic_vector((unsigned(A_i) + unsigned(B_i)));

					when "0001" =>
						senial_aux_sal <= std_logic_vector((unsigned(A_i) - unsigned(B_i)));
					
					when "0010" =>
						senial_aux_sal <= not A_i;

					when "0011" =>
						senial_aux_sal <= A_i and B_i;

					when "0100" =>
						senial_aux_sal <= A_i or B_i;
					
					when "0101" =>
						senial_aux_sal <= A_i xor B_i;
						
					when "0110" =>
						senial_aux_sal <= std_logic_vector(shift_right(unsigned(A_i), to_integer(unsigned(B_i))));	
					
					when "0111" =>
						senial_aux_sal <= std_logic_vector(shift_left(unsigned(A_i), to_integer(unsigned(B_i))));		
								
					when "1000" =>
						aux1 := A_i(N-1);	-- se guarda el bit de signo
						aux2 := std_logic_vector(shift_right(unsigned(A_i), to_integer(unsigned(B_i)))); --se hace el desplazamiento
						
						-- Se rellenan los bits desplazados con el bit mas significativo
						
						if to_integer(unsigned(B_i)) > N then
							aux2 := (others => aux1);
						else
							aux2(N-1 downto N-1-to_integer(unsigned(B_i))) := (others => aux1);
						end if;

						senial_aux_sal <= aux2;				

					when others => senial_aux_sal <= std_logic_vector(to_unsigned(0,N));		
		end case;
		
	end process;
end implementacion;
