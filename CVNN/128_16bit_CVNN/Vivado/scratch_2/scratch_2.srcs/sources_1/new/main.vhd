----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/19/2023 04:04:15 PM
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
           x_imag : in batch_x_array;
           y_out_real : out y_array;
           y_out_imag : out y_array);
end main;

architecture Behavioral of main is

component mult_complex
    port ( 
           a_real : in SIGNED (N-1 downto 0);
           a_imag : in SIGNED (N-1 downto 0);
           b_real : in SIGNED (N-1 downto 0);
           b_imag : in SIGNED (N-1 downto 0);
           c_real : out SIGNED (N-1 downto 0);
           c_imag : out SIGNED (N-1 downto 0)--;
           --clk : in std_logic
           );
end component;

component tansig
    port (
        clk : in std_logic;
        x : in signed(N-1 downto 0);
        x_i : in signed(N-1 downto 0);
        y : out signed(N-1 downto 0);
        y_i : out signed(N-1 downto 0));
end component;


component n_output
    port (
        clk : in std_logic;
        x,x_i, w,w_i : in a_array;
        bi,bi_i : in signed(N-1 downto 0);
        sum_out : out signed(N-1 downto 0);
        sum_out_i : out signed(N-1 downto 0));
end component;


    constant Stage_1 : integer := 4;
    constant Stage_2 : integer := 2;
--    constant Stage_3 : integer := 2;

    type a_array_Stage_1 is array(0 to Stage_1-1) of signed(N-1 downto 0); -- Array of hidden activation function 
    type a_array_Stage_2 is array(0 to Stage_2-1) of signed(N-1 downto 0);
--    type a_array_Stage_3 is array(0 to Stage_3-1) of signed(N-1 downto 0);
    
    type xw1_array_Stage_1 is array (0 to NUM_L1-1) of a_array_Stage_1;
    type xw1_array_Stage_2 is array (0 to NUM_L1-1) of a_array_Stage_2;
--    type xw1_array_Stage_3 is array (0 to NUM_L1-1) of a_array_Stage_3;
    
    signal mult_sum_1_real : xw1_array_Stage_1;
    signal mult_sum_2_real : xw1_array_Stage_2;
--    signal mult_sum_3_real : xw1_array_Stage_3;
    
    signal mult_sum_1_imag : xw1_array_Stage_1;
    signal mult_sum_2_imag : xw1_array_Stage_2;
--    signal mult_sum_3_imag : xw1_array_Stage_3;
    
    type xw1_last_Stage is array(0 to NUM_L1-1) of signed(N-1 downto 0);
    
    signal mult_sum_batch_1_real : xw1_last_Stage;
    signal mult_sum_batch_1_imag : xw1_last_Stage;
    

    signal outputoutput : xw1_last_Stage;

-- Intermediate signal declarations
    signal b1 : b1_array;
    signal b1_i : b1_array;
    signal w1 : w1_array;
    signal w1_i : w1_array;
    signal b2 : b2_array;
    signal b2_i : b2_array;
    signal w2 : w2_array;
    signal w2_i : w2_array;
    signal sum2_real : sum2_array;
    signal sum2_imag : sum2_array;
    
    
   

signal temp : signed(2*N-1 downto 0);
signal temp2 : signed(N-1 downto 0);
--signal mult_array : batch_x_array;

type mult_array is array(0 to BATCH_X-1) of signed(N-1 downto 0);
type xw1_array is array (0 to NUM_L1-1) of mult_array;

signal mult_Batch_real : xw1_array;
signal mult_Batch_imag : xw1_array;
signal aa_real : xw1_array;
signal aa_imag : xw1_array;
signal bb_real : xw1_array;
signal bb_imag : xw1_array;
signal cc_real : xw1_array;
signal cc_imag : xw1_array;
signal W1_Count : integer :=0;
signal Batch_Count : integer :=0;

signal outputG : signed(N-1 downto 0);

--signal stage_1_xw_real : xw1_last_Stage;
signal stage_2_xw_real : xw1_last_Stage;
signal stage_3_xw_real : xw1_last_Stage;
signal stage_4_xw_real : xw1_last_Stage;
signal stage_5_xw_real : xw1_last_Stage;
signal stage_6_xw_real : xw1_last_Stage;
signal stage_7_xw_real : xw1_last_Stage;
signal stage_8_xw_real : xw1_last_Stage;
signal stage_9_xw_real : xw1_last_Stage;
signal stage_10_xw_real : xw1_last_Stage;
signal stage_11_xw_real : xw1_last_Stage;
signal stage_12_xw_real : xw1_last_Stage;
signal stage_13_xw_real : xw1_last_Stage;
signal stage_14_xw_real : xw1_last_Stage;
signal stage_15_xw_real : xw1_last_Stage;
signal stage_16_xw_real : xw1_last_Stage;

--signal stage_1_xw_imag : xw1_last_Stage;
signal stage_2_xw_imag : xw1_last_Stage;
signal stage_3_xw_imag : xw1_last_Stage;
signal stage_4_xw_imag : xw1_last_Stage;
signal stage_5_xw_imag : xw1_last_Stage;
signal stage_6_xw_imag : xw1_last_Stage;
signal stage_7_xw_imag : xw1_last_Stage;
signal stage_8_xw_imag : xw1_last_Stage;
signal stage_9_xw_imag : xw1_last_Stage;
signal stage_10_xw_imag : xw1_last_Stage;
signal stage_11_xw_imag : xw1_last_Stage;
signal stage_12_xw_imag : xw1_last_Stage;
signal stage_13_xw_imag : xw1_last_Stage;
signal stage_14_xw_imag : xw1_last_Stage;
signal stage_15_xw_imag : xw1_last_Stage;
signal stage_16_xw_imag : xw1_last_Stage;

signal stage_1_xw_real_reg : xw1_last_Stage;
signal stage_2_xw_real_reg : xw1_last_Stage;
signal stage_3_xw_real_reg : xw1_last_Stage;
signal stage_4_xw_real_reg : xw1_last_Stage;
signal stage_5_xw_real_reg : xw1_last_Stage;
signal stage_6_xw_real_reg : xw1_last_Stage;
signal stage_7_xw_real_reg : xw1_last_Stage;
signal stage_8_xw_real_reg : xw1_last_Stage;
signal stage_9_xw_real_reg : xw1_last_Stage;
signal stage_10_xw_real_reg : xw1_last_Stage;
signal stage_11_xw_real_reg : xw1_last_Stage;
signal stage_12_xw_real_reg : xw1_last_Stage;
signal stage_13_xw_real_reg : xw1_last_Stage;
signal stage_14_xw_real_reg : xw1_last_Stage;
signal stage_15_xw_real_reg : xw1_last_Stage;
signal stage_16_xw_real_reg : xw1_last_Stage;

signal stage_1_xw_imag_reg : xw1_last_Stage;
signal stage_2_xw_imag_reg : xw1_last_Stage;
signal stage_3_xw_imag_reg : xw1_last_Stage;
signal stage_4_xw_imag_reg : xw1_last_Stage;
signal stage_5_xw_imag_reg : xw1_last_Stage;
signal stage_6_xw_imag_reg : xw1_last_Stage;
signal stage_7_xw_imag_reg : xw1_last_Stage;
signal stage_8_xw_imag_reg : xw1_last_Stage;
signal stage_9_xw_imag_reg : xw1_last_Stage;
signal stage_10_xw_imag_reg : xw1_last_Stage;
signal stage_11_xw_imag_reg : xw1_last_Stage;
signal stage_12_xw_imag_reg : xw1_last_Stage;
signal stage_13_xw_imag_reg : xw1_last_Stage;
signal stage_14_xw_imag_reg : xw1_last_Stage;
signal stage_15_xw_imag_reg : xw1_last_Stage;
signal stage_16_xw_imag_reg : xw1_last_Stage;

signal final_xw_b_real : xw1_last_Stage;
signal final_xw_b_imag : xw1_last_Stage;


signal a1_real : a_array;
signal a1_imag : a_array;
signal a2_real : y_array;
signal a2_imag : y_array;

signal a1_real_reg : a_array;
signal a1_imag_reg : a_array;

signal CLK_8_STEP : integer :=0;
signal first_batch : integer :=0;


begin

-- Generate signed hidden layer weights and biases
    W1GEN: for j in 0 to NUM_L1-1 generate
    begin
        W1GEN_1:for i in 0 to NUM_X-1 generate
        begin
            w1(j)(i) <= to_signed(INTEGER(w1r(j*NUM_X+i)*ONE), N);
            w1_i(j)(i) <= to_signed(INTEGER(w1r_imag(j*NUM_X+i)*ONE), N);
        end generate;
        b1(j) <= to_signed(INTEGER(b1r(j)*ONE), N);
        b1_i(j) <= to_signed(INTEGER(b1r_imag(j)*ONE), N);
    end generate;

-- Generate signed output layer weights and biases
    W2GEN: for j in 0 to NUM_Y-1 generate
    begin
        W2GEN_2:for i in 0 to NUM_L1-1 generate
        begin
            w2(j)(i) <= to_signed(INTEGER(w2r(j*NUM_L1+i)*ONE), N);
            w2_i(j)(i) <= to_signed(INTEGER(w2r_imag(j*NUM_L1+i)*ONE), N);
        end generate;
        b2(j) <= to_signed(INTEGER(b2r(j)*ONE), N);
        b2_i(j) <= to_signed(INTEGER(b2r_imag(j)*ONE), N);
    end generate;


process(clk)
begin
    if (rising_edge(clk))then
    
        for j in 0 to NUM_L1-1 loop
            for i in 0 to BATCH_X - 1 loop
                --mult_sum_real(i) <= x_real(i) * w1(1)(i);
                aa_real(j)(i) <= x_real(i);
                aa_imag(j)(i) <= x_imag(i);
                bb_real(j)(i) <= w1(j)(Batch_Count*BATCH_X+i);
                bb_imag(j)(i) <= w1_i(j)(Batch_Count*BATCH_X+i);
                mult_Batch_real(j)(i) <= cc_real(j)(i);
                mult_Batch_imag(j)(i) <= cc_imag(j)(i);
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
        
        
        
        stage_1_xw_real_reg <= mult_sum_batch_1_real;
        stage_2_xw_real_reg <= stage_2_xw_real;
        stage_3_xw_real_reg <= stage_3_xw_real;
        stage_4_xw_real_reg <= stage_4_xw_real;
        stage_5_xw_real_reg <= stage_5_xw_real;
        stage_6_xw_real_reg <= stage_6_xw_real;
        stage_7_xw_real_reg <= stage_7_xw_real;
        --TEMP_8_STEP_REAL <= stage_8_xw_real;
        stage_8_xw_real_reg <= stage_8_xw_real;
        stage_9_xw_real_reg <= stage_9_xw_real;
        stage_10_xw_real_reg <= stage_10_xw_real;
        stage_11_xw_real_reg <= stage_11_xw_real;
        stage_12_xw_real_reg <= stage_12_xw_real;
        stage_13_xw_real_reg <= stage_13_xw_real;
        stage_14_xw_real_reg <= stage_14_xw_real;
        stage_15_xw_real_reg <= stage_15_xw_real;
        
        stage_1_xw_imag_reg <= mult_sum_batch_1_imag;
        stage_2_xw_imag_reg <= stage_2_xw_imag;
        stage_3_xw_imag_reg <= stage_3_xw_imag;
        stage_4_xw_imag_reg <= stage_4_xw_imag;
        stage_5_xw_imag_reg <= stage_5_xw_imag;
        stage_6_xw_imag_reg <= stage_6_xw_imag;
        stage_7_xw_imag_reg <= stage_7_xw_imag;
        --TEMP_8_STEP_IMAG <= stage_8_xw_imag;
        stage_8_xw_imag_reg <= stage_8_xw_imag;
        stage_9_xw_imag_reg <= stage_9_xw_imag;
        stage_10_xw_imag_reg <= stage_10_xw_imag;
        stage_11_xw_imag_reg <= stage_11_xw_imag;
        stage_12_xw_imag_reg <= stage_12_xw_imag;
        stage_13_xw_imag_reg <= stage_13_xw_imag;
        stage_14_xw_imag_reg <= stage_14_xw_imag;
        stage_15_xw_imag_reg <= stage_15_xw_imag;
        
        
        a1_real_reg <= a1_real;
        a1_imag_reg <= a1_imag;
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
                stage_16_xw_real_reg <= stage_16_xw_real; 
                stage_16_xw_imag_reg <= stage_16_xw_imag;
            end if;
        else
            if CLK_8_STEP >= NUMBER_OF_BATCH-1 then
                CLK_8_STEP <=0;
                stage_16_xw_real_reg <= stage_16_xw_real; 
                stage_16_xw_imag_reg <= stage_16_xw_imag;
            end if;
        end if;
    end if;
end process;

--TEMP_81_STEP_REAL <= TEMP_8_STEP_REAL

multgen_L : for j in 0 to NUM_L1-1 generate
    begin
        multgen : for i in 0 to BATCH_X-1 generate
            begin
                mult_unit: mult_complex
                port map (
                            
                            a_real=>aa_real(j)(i),
                            a_imag=>aa_imag(j)(i), 
                            b_real=>bb_real(j)(i), 
                            b_imag=>bb_imag(j)(i), 
                            c_real=>cc_real(j)(i),
                            c_imag=>cc_imag(j)(i)
                        );
        end generate;
end generate;

    -- real and imaginary part calculation
    addergen_1_L : for j in 0 to NUM_L1-1 generate
        begin
            addergen_1 : for i in 0 to Stage_1-1 generate
                begin               
                     mult_sum_1_real(j)(i) <= mult_Batch_real(j)(2*i)+ mult_Batch_real(j)(2*i+1);
                     mult_sum_1_imag(j)(i) <=  mult_Batch_imag(j)(2*i) + mult_Batch_imag(j)(2*i+1);         
            end generate;
    end generate;
    
    addergen_2_L : for j in 0 to NUM_L1-1 generate
        begin
            addergen_2 : for i in 0 to Stage_2-1 generate
                begin
                     mult_sum_2_real(j)(i)<= mult_sum_1_real(j)(2*i)+mult_sum_1_real(j)(2*i+1);
                     mult_sum_2_imag(j)(i)<= mult_sum_1_imag(j)(2*i)+mult_sum_1_imag(j)(2*i+1);           
            end generate;
    end generate;
    
--    addergen_3_L : for j in 0 to NUM_L1-1 generate
--        begin
--            addergen_3 : for i in 0 to Stage_3-1 generate
--                begin
--                     mult_sum_3_real(j)(i)<=mult_sum_2_real(j)(2*i)+mult_sum_2_real(j)(2*i+1);
--                     mult_sum_3_imag(j)(i)<=mult_sum_2_imag(j)(2*i)+mult_sum_2_imag(j)(2*i+1);             
--            end generate;
--    end generate;
    
    addergen_last : for j in 0 to NUM_L1-1 generate
        begin
            mult_sum_batch_1_real(j) <= mult_sum_2_real(j)(0)+mult_sum_2_real(j)(1);
            mult_sum_batch_1_imag(j) <= mult_sum_2_imag(j)(0)+mult_sum_2_imag(j)(1);
    end generate;
    



-- All Batach addition 
adderGenLastReg : for j in 0 to NUM_L1-1 generate
    begin
        stage_2_xw_real(j) <= stage_1_xw_real_reg(j) + mult_sum_batch_1_real(j);
        stage_3_xw_real(j) <= stage_2_xw_real_reg(j) + mult_sum_batch_1_real(j);
        stage_4_xw_real(j) <= stage_3_xw_real_reg(j) + mult_sum_batch_1_real(j);
        stage_5_xw_real(j) <= stage_4_xw_real_reg(j) + mult_sum_batch_1_real(j);
        stage_6_xw_real(j) <= stage_5_xw_real_reg(j) + mult_sum_batch_1_real(j);
        stage_7_xw_real(j) <= stage_6_xw_real_reg(j) + mult_sum_batch_1_real(j);
        stage_8_xw_real(j) <= stage_7_xw_real_reg(j) + mult_sum_batch_1_real(j);
        stage_9_xw_real(j) <= stage_8_xw_real_reg(j) + mult_sum_batch_1_real(j);
        stage_10_xw_real(j) <= stage_9_xw_real_reg(j) + mult_sum_batch_1_real(j);
        stage_11_xw_real(j) <= stage_10_xw_real_reg(j) + mult_sum_batch_1_real(j);
        stage_12_xw_real(j) <= stage_11_xw_real_reg(j) + mult_sum_batch_1_real(j);
        stage_13_xw_real(j) <= stage_12_xw_real_reg(j) + mult_sum_batch_1_real(j);
        stage_14_xw_real(j) <= stage_13_xw_real_reg(j) + mult_sum_batch_1_real(j);
        stage_15_xw_real(j) <= stage_14_xw_real_reg(j) + mult_sum_batch_1_real(j);
        stage_16_xw_real(j) <= stage_15_xw_real_reg(j) + mult_sum_batch_1_real(j);
        
        stage_2_xw_imag(j) <= stage_1_xw_imag_reg(j) + mult_sum_batch_1_imag(j);
        stage_3_xw_imag(j) <= stage_2_xw_imag_reg(j) + mult_sum_batch_1_imag(j);
        stage_4_xw_imag(j) <= stage_3_xw_imag_reg(j) + mult_sum_batch_1_imag(j);
        stage_5_xw_imag(j) <= stage_4_xw_imag_reg(j) + mult_sum_batch_1_imag(j);
        stage_6_xw_imag(j) <= stage_5_xw_imag_reg(j) + mult_sum_batch_1_imag(j);
        stage_7_xw_imag(j) <= stage_6_xw_imag_reg(j) + mult_sum_batch_1_imag(j);
        stage_8_xw_imag(j) <= stage_7_xw_imag_reg(j) + mult_sum_batch_1_imag(j);
        stage_9_xw_imag(j) <= stage_8_xw_imag_reg(j) + mult_sum_batch_1_imag(j);
        stage_10_xw_imag(j) <= stage_9_xw_imag_reg(j) + mult_sum_batch_1_imag(j);
        stage_11_xw_imag(j) <= stage_10_xw_imag_reg(j) + mult_sum_batch_1_imag(j);
        stage_12_xw_imag(j) <= stage_11_xw_imag_reg(j) + mult_sum_batch_1_imag(j);
        stage_13_xw_imag(j) <= stage_12_xw_imag_reg(j) + mult_sum_batch_1_imag(j);
        stage_14_xw_imag(j) <= stage_13_xw_imag_reg(j) + mult_sum_batch_1_imag(j);
        stage_15_xw_imag(j) <= stage_14_xw_imag_reg(j) + mult_sum_batch_1_imag(j);
        stage_16_xw_imag(j) <= stage_15_xw_imag_reg(j) + mult_sum_batch_1_imag(j);
end generate;

adderGenWX_B : for j in 0 to NUM_L1-1 generate
    begin
        final_xw_b_real(j) <= stage_16_xw_real_reg(j)+b1(j);
        final_xw_b_imag(j) <= stage_16_xw_imag_reg(j)+b1_i(j);
end generate;


--Tansig transfer function for hidden layer
    TF1GEN: for j in 0 to NUM_L1-1 generate
        begin
            tansig_unit: tansig
                port map (
                            clk=>clk,
                            x=>final_xw_b_real(j),
                            x_i=>final_xw_b_imag(j), 
                            y=>a1_real(j),
                            y_i=>a1_imag(j)
                        );
    end generate;


-- Output layer neurons
L2GEN: for i in 0 to NUM_Y-1 generate
begin
    output_unit: n_output
    port map (
                clk=>clk,
                x=>a1_real_reg,
                x_i=>a1_imag_reg, 
                w=>w2(i),
                w_i=>w2_i(i),
                bi=>b2(i),
                bi_i=>b2_i(i), 
                sum_out=>sum2_real(i),
                sum_out_i=>sum2_imag(i)
            );
    end generate;
    
--Tansig transfer function for hidden layer
    ActivationOutGEN: for j in 0 to NUM_Y-1 generate
        begin
            tansig_unit: tansig
                port map (
                            clk=>clk,
                            x=>sum2_real(j),
                            x_i=>sum2_imag(j), 
                            y=>a2_real(j),
                            y_i=>a2_imag(j)
                        );
    end generate;

y_out_real <= a2_real;
y_out_imag <= a2_imag;

end Behavioral;
