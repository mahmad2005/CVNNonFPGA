----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/23/2023 07:05:59 PM
-- Design Name: 
-- Module Name: nn_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

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
        y_out_real: out y_array);
end component;


signal magnitude : y_array;

signal clk : std_logic;
signal x : batch_x_array;
--signal x_imag : batch_x_array;
signal y : y_array;
--signal y_imag : y_array;

signal CLK_Out : integer :=0;
signal first_clk_out : integer :=0;

signal Predicted_Class : integer range 0 to NUM_Y-1;

begin

file_open(file_RESULTS, "output_results.txt", write_mode);

process
begin
    for j in 0 to 10*NUMBER_OF_BATCH-1 loop
        for i in 0 to BATCH_X-1 loop
            x(i)<= to_signed(integer(input_1(i+j*BATCH_X)*ONE),N);
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






NN_unit: main
    port map (clk=>clk, x_real => x, y_out_real => y);



magnitude <= y;
    
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
        end loop;
        Predicted_Class <= max_idx;
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



end Behavioral;