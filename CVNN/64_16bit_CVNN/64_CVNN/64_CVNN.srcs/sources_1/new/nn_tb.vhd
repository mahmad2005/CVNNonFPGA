library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.textio.all;
use work.nn_package.all;

entity nn_tb is
--  Port ( );
end nn_tb;

architecture Behavioral of nn_tb is

--file result : text is out "FinalData.txt";
file file_RESULTS : text;

component main is
    Port ( 
        clk: in std_logic;
        x_real: in batch_x_array;
        x_imag: in batch_x_array;
        y_out_real: out y_array;
        y_out_imag: out y_array);
end component;

--component mult is
--    Port ( a : in SIGNED (N-1 downto 0);
--           b : in SIGNED (N-1 downto 0);
--           c : out SIGNED (N-1 downto 0)--;
--           --clk : in std_logic
--           );
--end component;

--component MaxIndexFinder is
--    port (
--            magnitude : in  y_array;  -- Input magnitude array
--            max_index : out integer range 0 to NUM_Y-1
--        );
--end component;

 --type mag_array is array(0 to NUM_Y-1) of signed(N-1 downto 0);
 type mag_array is array(0 to NUM_Y-1) of signed(2*N-1 downto 0); -- Array of outputs
 signal magnitude_r : mag_array;
 signal magnitude_i : mag_array;
 signal magnitude : mag_array;

signal clk : std_logic;
signal x : batch_x_array;
signal x_imag : batch_x_array;
signal y : y_array;
signal y_imag : y_array;

signal CLK_Out : integer :=0;
signal first_clk_out : integer :=0;

signal Predicted_Class : integer range 0 to NUM_Y-1;

begin

file_open(file_RESULTS, "output_results.txt", write_mode);

process
begin
    for j in 0 to 30*NUMBER_OF_BATCH-1 loop
        for i in 0 to BATCH_X-1 loop
            x(i)<= to_signed(integer(input_1(i+j*BATCH_X)*ONE),N);
            x_imag(i)<= to_signed(integer(input_1_i(i+j*BATCH_X)*ONE),N);
        end loop;
    wait for 20ns;
    end loop;
end process;

process
begin
clk <= '0';
wait for 10ns;
clk <= '1';
wait for 10ns;
end process;

--process
--begin
--for i in 0 to 127 loop
--	x(i)<= to_signed(integer(input_1(i)*ONE),N);
----	x(1)<= to_signed(integer(input_2(i)*ONE),N);
----	x(2)<= to_signed(integer(input_3(i)*ONE),N);
	
--	x_imag(i)<= to_signed(integer(input_1_i(i)*ONE),N);
----	x_imag(1)<= to_signed(integer(input_2_i(i)*ONE),N);
----	x_imag(2)<= to_signed(integer(input_3_i(i)*ONE),N);
--	wait for 20ns;
--	end loop;
--end process;

NN_unit: main
    port map (clk=>clk, x_real => x, x_imag => x_imag, y_out_real => y, y_out_imag => y_imag);


multgen : for i in 0 to NUM_Y-1 generate
              magnitude_r(i) <= y(i)*y(i);
              magnitude_i(i) <= y_imag(i)*y_imag(i);
   end generate;

addgen : for i in 0 to NUM_Y-1 generate
    magnitude(i) <= magnitude_r(i) + magnitude_i(i);
    end generate; 
    
process(clk)
variable max_val : integer :=0;
variable max_idx : integer :=0;


begin
    if (rising_edge(clk))then
        for i in 0 to NUM_Y-1 loop
            if max_val < to_integer(magnitude(i)) then
                max_val := to_integer(magnitude(i));
                max_idx := integer(i);
             end if;
             --max_val := integer(5);
        end loop;
        Predicted_Class <= max_idx;
        --write(outLine_cos,real(max_idx));
        --writeline(file_RESULTS,outLine_cos);
    else
        max_val :=0;
        max_idx :=0;
    end if;
end process;


process(CLK)
VARIABLE  outLine_cos  : LINE;
VARIABLE  outLine_sin  : LINE;
begin
    if (rising_edge(clk))then
        CLK_Out <= CLK_Out+1;
        
        if first_clk_out = 0 then
            if CLK_Out >= NUMBER_OF_BATCH+1 then
                CLK_Out <=0;
                first_clk_out <= 1;
                write(outLine_cos,real(Predicted_Class));
                writeline(file_RESULTS,outLine_cos);
            end if;
        else
            if CLK_Out >= NUMBER_OF_BATCH-1 then
                CLK_Out <=0;
                write(outLine_cos,real(Predicted_Class));
                writeline(file_RESULTS,outLine_cos);
            end if;
        end if;
    end if;
end process;    

--maxfind : MaxIndexFinder
--    port map (magnitude => magnitude , max_index =>max_index);

end Behavioral;