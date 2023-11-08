----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/22/2023 08:44:19 PM
-- Design Name: 
-- Module Name: main - Behavioral
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
use work.nn_package.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
  Port ( clk: in std_logic;
        x_real : in batch_x_array;
        y_out_real : out y_array);
        
end main;

architecture Behavioral of main is

component mult
    port ( 
           a : in SIGNED (N-1 downto 0);
           b : in SIGNED (N-1 downto 0);
           c : out SIGNED (N-1 downto 0)
           --clk : in std_logic
           );
end component;

component reluAct
    port (
        clk : in std_logic;
        x : in signed(N-1 downto 0);
        y : out signed(N-1 downto 0));
end component;

component n_output
    port (
        clk : in std_logic;
        x, w : in a_array;
        bi : in signed(N-1 downto 0);
        sum_out : out signed(N-1 downto 0));
end component;

    constant Stage_1 : integer := 8;
    constant Stage_2 : integer := 4;
    constant Stage_3 : integer := 2;
    constant Stage_4 : integer := 2;
    
    
    type a_array_Stage_1 is array(0 to Stage_1-1) of signed(N-1 downto 0); -- Array of hidden activation function 
    type a_array_Stage_2 is array(0 to Stage_2-1) of signed(N-1 downto 0);
    type a_array_Stage_3 is array(0 to Stage_3-1) of signed(N-1 downto 0);
    type a_array_Stage_4 is array(0 to Stage_4-1) of signed(N-1 downto 0);
    
    type xw1_array_Stage_1 is array (0 to NUM_L1-1) of a_array_Stage_1;
    type xw1_array_Stage_2 is array (0 to NUM_L1-1) of a_array_Stage_2;
    type xw1_array_Stage_3 is array (0 to NUM_L1-1) of a_array_Stage_3;
    type xw1_array_Stage_4 is array (0 to NUM_L1-1) of a_array_Stage_4;
    
    signal mult_sum_1_real : xw1_array_Stage_1;
    signal mult_sum_2_real : xw1_array_Stage_2;
    signal mult_sum_3_real : xw1_array_Stage_3;
    signal mult_sum_4_real : xw1_array_Stage_4;
    
    type xw1_last_Stage is array(0 to NUM_L1-1) of signed(N-1 downto 0);
    
    type xw_array_last_Stage_all is array(0 to NUMBER_OF_BATCH-1) of xw1_last_Stage;
    
--    signal mult_sum_batch_1_real : xw1_last_Stage;
    

-- Intermediate signal declarations
    signal b1 : b1_array;
    signal w1 : w1_array;
    signal b2 : b2_array;
    signal w2 : w2_array;
    signal sum2_real : sum2_array;
    
    type mult_array is array(0 to BATCH_X-1) of signed(N-1 downto 0);
    type xw1_array is array (0 to NUM_L1-1) of mult_array;
    
    
    signal mult_Batch_real : xw1_array;
    signal aa_real : xw1_array;
    signal bb_real : xw1_array;
    signal cc_real : xw1_array;
    signal W1_Count : integer :=0;
    signal Batch_Count : integer :=0;
    
--    --signal stage_1_xw_real : xw1_last_Stage;
--    signal stage_2_xw_real : xw1_last_Stage;
--    signal stage_3_xw_real : xw1_last_Stage;
--    signal stage_4_xw_real : xw1_last_Stage;
--    signal stage_5_xw_real : xw1_last_Stage;
--    signal stage_6_xw_real : xw1_last_Stage;
--    signal stage_7_xw_real : xw1_last_Stage;
--    signal stage_8_xw_real : xw1_last_Stage;
--    signal stage_9_xw_real : xw1_last_Stage;
--    signal stage_10_xw_real : xw1_last_Stage;
--    signal stage_11_xw_real : xw1_last_Stage;
--    signal stage_12_xw_real : xw1_last_Stage;
--    signal stage_13_xw_real : xw1_last_Stage;
--    signal stage_14_xw_real : xw1_last_Stage;
--    signal stage_15_xw_real : xw1_last_Stage;
--    signal stage_16_xw_real : xw1_last_Stage;
    
--    signal stage_1_xw_real_reg : xw1_last_Stage;
--    signal stage_2_xw_real_reg : xw1_last_Stage;
--    signal stage_3_xw_real_reg : xw1_last_Stage;
--    signal stage_4_xw_real_reg : xw1_last_Stage;
--    signal stage_5_xw_real_reg : xw1_last_Stage;
--    signal stage_6_xw_real_reg : xw1_last_Stage;
--    signal stage_7_xw_real_reg : xw1_last_Stage;
--    signal stage_8_xw_real_reg : xw1_last_Stage;
--    signal stage_9_xw_real_reg : xw1_last_Stage;
--    signal stage_10_xw_real_reg : xw1_last_Stage;
--    signal stage_11_xw_real_reg : xw1_last_Stage;
--    signal stage_12_xw_real_reg : xw1_last_Stage;
--    signal stage_13_xw_real_reg : xw1_last_Stage;
--    signal stage_14_xw_real_reg : xw1_last_Stage;
--    signal stage_15_xw_real_reg : xw1_last_Stage;
--    signal stage_16_xw_real_reg : xw1_last_Stage;
    
    signal final_xw_b_real : xw1_last_Stage;
    
    signal CLK_8_STEP : integer :=0;
    signal first_batch : integer :=0;
    
    signal a1_real : a_array;
    signal a2_real : y_array;
    
    signal a1_real_reg : a_array;
    
    signal all_stage_xw_real : xw_array_last_Stage_all;
    signal all_stage_xw_real_reg : xw_array_last_Stage_all;
    
begin

-- Generate signed hidden layer weights and biases
    W1GEN: for j in 0 to NUM_L1-1 generate
    begin
        W1GEN_1:for i in 0 to NUM_X-1 generate
        begin
            w1(j)(i) <= to_signed(INTEGER(w1r(j*NUM_X+i)*ONE), N);
        end generate;
        b1(j) <= to_signed(INTEGER(b1r(j)*ONE), N);
    end generate;
    
-- Generate signed output layer weights and biases
    W2GEN: for j in 0 to NUM_Y-1 generate
    begin
        W2GEN_2:for i in 0 to NUM_L1-1 generate
        begin
            w2(j)(i) <= to_signed(INTEGER(w2r(j*NUM_L1+i)*ONE), N);
        end generate;
        b2(j) <= to_signed(INTEGER(b2r(j)*ONE), N);
    end generate;

process(clk)
begin
    if (rising_edge(clk))then
    
        for j in 0 to NUM_L1-1 loop
            for i in 0 to BATCH_X - 1 loop
                --mult_sum_real(i) <= x_real(i) * w1(1)(i);
                aa_real(j)(i) <= x_real(i);
                bb_real(j)(i) <= w1(j)(Batch_Count*BATCH_X+i);
                mult_Batch_real(j)(i) <= cc_real(j)(i);
            end loop;
        end loop;
        
        W1_Count <= W1_Count+1;
        Batch_Count <= Batch_Count+1;
        
        if W1_Count >= NUM_L1-1 then
            W1_Count <= 0;
        end if;
        if Batch_Count >= NUMBER_OF_BATCH-1 then
            Batch_Count <= 0;
        end if;
        
--        all_stage_xw_real_reg(0) <= all_stage_xw_real(0);
--        all_stage_xw_real_reg(1) <= all_stage_xw_real(1);
--        all_stage_xw_real_reg(2) <= all_stage_xw_real(2);
--        all_stage_xw_real_reg(3) <= all_stage_xw_real(3);
--        all_stage_xw_real_reg(4) <= all_stage_xw_real(4);
--        all_stage_xw_real_reg(5) <= all_stage_xw_real(5);
--        all_stage_xw_real_reg(6) <= all_stage_xw_real(6);
--        all_stage_xw_real_reg(7) <= all_stage_xw_real(7);
--        all_stage_xw_real_reg(8) <= all_stage_xw_real(8);
--        all_stage_xw_real_reg(9) <= all_stage_xw_real(9);
--        all_stage_xw_real_reg(10) <= all_stage_xw_real(10);
--        all_stage_xw_real_reg(11) <= all_stage_xw_real(11);
--        all_stage_xw_real_reg(12) <= all_stage_xw_real(12);
--        all_stage_xw_real_reg(13) <= all_stage_xw_real(13);
--        all_stage_xw_real_reg(14) <= all_stage_xw_real(14);
        

        
        all_stage_xw_real_reg(0 to NUMBER_OF_BATCH-2) <= all_stage_xw_real(0 to NUMBER_OF_BATCH-2);
        
    
        a1_real_reg <= a1_real;
    end if;
end process;


process(CLK)
begin
    if (rising_edge(clk))then
        CLK_8_STEP <= CLK_8_STEP+1;
        
        if first_batch = 0 then
            if CLK_8_STEP >= NUMBER_OF_BATCH+1 then
                CLK_8_STEP <=0;
                first_batch <= 1;
                all_stage_xw_real_reg(NUMBER_OF_BATCH-1) <= all_stage_xw_real(NUMBER_OF_BATCH-1); 
            end if;
        else
            if CLK_8_STEP >= NUMBER_OF_BATCH-1 then
                CLK_8_STEP <=0;
                all_stage_xw_real_reg(NUMBER_OF_BATCH-1) <= all_stage_xw_real(NUMBER_OF_BATCH-1); 
            end if;
        end if;
    end if;
end process;

--XW multiplication
multgen_L : for j in 0 to NUM_L1-1 generate
    begin
        multgen : for i in 0 to BATCH_X-1 generate
            begin
                mult_unit: mult
                port map (
                            
                            a=>aa_real(j)(i),
                            b=>bb_real(j)(i), 
                            c=>cc_real(j)(i)
                        );
        end generate;
end generate;


-- XW summation per batch
addergen_1_L : for j in 0 to NUM_L1-1 generate
    begin
        addergen_1 : for i in 0 to Stage_1-1 generate
            begin               
                 mult_sum_1_real(j)(i) <= mult_Batch_real(j)(2*i)+ mult_Batch_real(j)(2*i+1);        
        end generate;
end generate;

addergen_2_L : for j in 0 to NUM_L1-1 generate
    begin
        addergen_2 : for i in 0 to Stage_2-1 generate
            begin
                 mult_sum_2_real(j)(i)<= mult_sum_1_real(j)(2*i)+mult_sum_1_real(j)(2*i+1);           
        end generate;
end generate;

addergen_3_L : for j in 0 to NUM_L1-1 generate
    begin
        addergen_3 : for i in 0 to Stage_3-1 generate
            begin
                 mult_sum_3_real(j)(i)<=mult_sum_2_real(j)(2*i)+mult_sum_2_real(j)(2*i+1);            
        end generate;
end generate;

--addergen_4_L : for j in 0 to NUM_L1-1 generate
--    begin
--        addergen_4 : for i in 0 to Stage_4-1 generate
--            begin
--                 mult_sum_4_real(j)(i)<=mult_sum_3_real(j)(2*i)+mult_sum_3_real(j)(2*i+1);            
--        end generate;
--end generate;

addergen_last : for j in 0 to NUM_L1-1 generate
    begin
        --mult_sum_batch_1_real(j) <= mult_sum_3_real(j)(0)+mult_sum_3_real(j)(1);
        all_stage_xw_real(0)(j) <= mult_sum_3_real(j)(0)+mult_sum_3_real(j)(1);
end generate;
    
    
-- All Batach addition 
--adderGenLastReg : for j in 0 to NUM_L1-1 generate
--    begin
--        all_stage_xw_real(1)(j) <= all_stage_xw_real_reg(0)(j) + all_stage_xw_real(0)(j);
--        all_stage_xw_real(2)(j) <= all_stage_xw_real_reg(1)(j) + all_stage_xw_real(0)(j);
--        all_stage_xw_real(3)(j) <= all_stage_xw_real_reg(2)(j) + all_stage_xw_real(0)(j);
--        all_stage_xw_real(4)(j) <= all_stage_xw_real_reg(3)(j) + all_stage_xw_real(0)(j);
--        all_stage_xw_real(5)(j) <= all_stage_xw_real_reg(4)(j) + all_stage_xw_real(0)(j);
--        all_stage_xw_real(6)(j) <= all_stage_xw_real_reg(5)(j) + all_stage_xw_real(0)(j);
--        all_stage_xw_real(7)(j) <= all_stage_xw_real_reg(6)(j) + all_stage_xw_real(0)(j);
--        all_stage_xw_real(8)(j) <= all_stage_xw_real_reg(7)(j) + all_stage_xw_real(0)(j);
--        all_stage_xw_real(9)(j) <= all_stage_xw_real_reg(8)(j) + all_stage_xw_real(0)(j);
--        all_stage_xw_real(10)(j) <= all_stage_xw_real_reg(9)(j) + all_stage_xw_real(0)(j);
--        all_stage_xw_real(11)(j) <= all_stage_xw_real_reg(10)(j) + all_stage_xw_real(0)(j);
--        all_stage_xw_real(12)(j) <= all_stage_xw_real_reg(11)(j) + all_stage_xw_real(0)(j);
--        all_stage_xw_real(13)(j) <= all_stage_xw_real_reg(12)(j) + all_stage_xw_real(0)(j);
--        all_stage_xw_real(14)(j) <= all_stage_xw_real_reg(13)(j) + all_stage_xw_real(0)(j);
--        all_stage_xw_real(15)(j) <= all_stage_xw_real_reg(14)(j) + all_stage_xw_real(0)(j);
        
--end generate;


adderGenLastReg_i : for i in 0 to NUMBER_OF_BATCH-2 generate
    begin
        adderGenLastReg_j : for j in 0 to NUM_L1-1 generate
            begin
                all_stage_xw_real(i+1)(j) <= all_stage_xw_real_reg(i)(j) + all_stage_xw_real(0)(j);
         end generate;        
end generate;

-- Sum(WX+B)
adderGenWX_B : for j in 0 to NUM_L1-1 generate
    begin
        final_xw_b_real(j) <= all_stage_xw_real_reg(NUMBER_OF_BATCH-1)(j)+b1(j);
end generate;


--Relu activation function for hidden layer
TF1GEN: for j in 0 to NUM_L1-1 generate
    begin
        relu_unit: reluAct
            port map (
                        clk=>clk,
                        x=>final_xw_b_real(j), 
                        y=>a1_real(j)
                    );
end generate;


-- Output layer neurons
L2GEN: for i in 0 to NUM_Y-1 generate
begin
    output_unit: n_output
    port map (
                clk=>clk,
                x=>a1_real_reg, 
                w=>w2(i),
                bi=>b2(i), 
                sum_out=>sum2_real(i)
            );
end generate;

--Relu Activation function for hidden layer
ActivationOutGEN: for j in 0 to NUM_Y-1 generate
    begin
        relu_unit: reluAct
            port map (
                        clk=>clk,
                        x=>sum2_real(j),
                        y=>a2_real(j)
                    );
end generate;    

y_out_real <= a2_real;    

end Behavioral;
