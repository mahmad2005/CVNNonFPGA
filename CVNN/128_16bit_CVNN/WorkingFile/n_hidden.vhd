
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
use work.nn_package.all;

entity n_hidden is
    Port ( 
        clk : in std_logic; 
        x,x_i, w, w_i : in x_array;
        bi, bi_i : in signed(N-1 downto 0);
        sum_out : out signed(N-1 downto 0);
        sum_out_i : out signed(N-1 downto 0));
end n_hidden;

architecture Behavioral of n_hidden is
component mult
        port( 
            a : in signed(N-1 downto 0);
            b : in signed(N-1 downto 0);
            c : out signed(N-1 downto 0)--;
            --clk : in std_logic
			);
    end component;

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

component adder
    port (
        A : in signed(N-1 downto 0);
        B : in signed(N-1 downto 0);
        C : out signed(N-1 downto 0)
    );
end component;

    constant Stage_1 : integer := 64;
    constant Stage_2 : integer := 32;
    constant Stage_3 : integer := 16;
    constant Stage_4 : integer := 8;
    constant Stage_5 : integer := 4;
    constant Stage_6 : integer := 2;
    
    constant log2_NUM_X: integer := integer(floor(log2(real(NUM_X)))); 
    type my_array is array (0 to NUM_X-1) of signed(N-1 downto 0);
    
    type a_array_Stage_1 is array(0 to Stage_1-1) of signed(N-1 downto 0); -- Array of hidden activation function 
    type a_array_Stage_2 is array(0 to Stage_2-1) of signed(N-1 downto 0);
    type a_array_Stage_3 is array(0 to Stage_3-1) of signed(N-1 downto 0);
    type a_array_Stage_4 is array(0 to Stage_4-1) of signed(N-1 downto 0);
    type a_array_Stage_5 is array(0 to Stage_5-1) of signed(N-1 downto 0);
    type a_array_Stage_6 is array(0 to Stage_6-1) of signed(N-1 downto 0);
    
    signal mult_sum_1 : a_array_Stage_1;
    signal mult_sum_2 : a_array_Stage_2;
    signal mult_sum_3 : a_array_Stage_3;
    signal mult_sum_4 : a_array_Stage_4;
    signal mult_sum_5 : a_array_Stage_5;
    signal mult_sum_6 : a_array_Stage_6;
    
    signal mult_sum_1_i : a_array_Stage_1;
    signal mult_sum_2_i : a_array_Stage_2;
    signal mult_sum_3_i : a_array_Stage_3;
    signal mult_sum_4_i : a_array_Stage_4;
    signal mult_sum_5_i : a_array_Stage_5;
    signal mult_sum_6_i : a_array_Stage_6;
    
    signal buff_mult_sum_1 : a_array_Stage_1;
    signal buff_mult_sum_1_i : a_array_Stage_1;

    signal mult_array: x_array;
    signal mult_array_i: x_array;
    signal sum: signed(N-1 downto 0);
    signal sum_i: signed(N-1 downto 0);
    signal bi_1 : signed (N-1 downto 0);
    signal bi_1_i : signed (N-1 downto 0);
    signal sum1, sum2: signed(N-1 downto 0);
    signal sum3 : signed(N-1 downto 0);
    signal sum4 : signed(N-1 downto 0);
    
    signal sum1_i, sum2_i, sum3_i, sum4_i : signed(N-1 downto 0);
    
    
    signal sum_stage : my_array;
    signal sum_stage_i : my_array;
    
    
    signal buff_mult_array: x_array;
    signal buff_mult_array_i: x_array;
    
    
    signal  xx_real : SIGNED (N-1 downto 0);
    signal  xx_imag : SIGNED (N-1 downto 0);
    signal  w1_real : SIGNED (N-1 downto 0);
    signal  w1_imag : SIGNED (N-1 downto 0);
    signal  cmult_real : SIGNED (N-1 downto 0);
    signal  cmult_imag : SIGNED (N-1 downto 0);
    
    signal loop_counter : integer := 0;
    signal iteration : integer := 0;
    
    



begin
process(clk)
begin
    if (rising_edge(clk))then
    sum <= sum4;
    bi_1<=bi;
    -- imaginary part 
    sum_i <= sum4_i;
    bi_1_i<=bi_i;
    
--    buff_mult_array <= mult_array;
--    buff_mult_array_i <= mult_array_i;
    
--    buff_mult_sum_1 <= mult_sum_1;
--    buff_mult_sum_1_i <= mult_sum_1_i;
    end if;
end process;


--process(clk)
----    variable loop_counter : integer := 0;
----    variable iteration : integer := 0;
--begin
--    if (rising_edge(clk))then
    
--        if loop_counter < NUM_X - 1 then
--            -- Increment loop_counter to keep track of iterations within a clock cycle
--            loop_counter <= loop_counter + 1;
--        else
--            -- Reset loop_counter when it reaches NUM_X-1 and increment the iteration
--            loop_counter <= 0;
--            iteration <= iteration + 1;
--        end if;
    
--            xx_real <= x(iteration);
--            xx_imag <= x_i(iteration);
--            w1_real <= w(iteration);
--            w1_imag <=w_i(iteration);
--            mult_array(iteration) <= cmult_real;
--            mult_array_i(iteration) <= cmult_imag;
--    end if;
--end process;


--mult_unit: mult_complex
--        port map (
                    
--                    a_real=>xx_real,
--                    a_imag=>xx_imag, 
--                    b_real=>w1_real, 
--                    b_imag=>w1_imag, 
--                    c_real=>cmult_real,
--                    c_imag=>cmult_imag
--                );


    -- Multiply each input with its corresponding weight
    -- YOUR CODE HERE
	multgen : for i in 0 to NUM_X-1 generate
        begin
            mult_unit: mult_complex
            port map (
						
						a_real=>x(i),
                        a_imag=>x_i(i), 
                        b_real=>w(i), 
                        b_imag=>w_i(i), 
                        c_real=>mult_array(i),
                        c_imag=>mult_array_i(i)
					);
        end generate;
    


    -- real and imaginary part calculation 	
	addergen_1 : for i in 0 to Stage_1-1 generate
        begin               
             mult_sum_1(i) <= mult_array(2*i)+mult_array(2*i+1);
             mult_sum_1_i(i) <=  mult_array_i(2*i) + mult_array_i(2*i+1);         
    end generate;
    
    addergen_2 : for i in 0 to Stage_2-1 generate
        begin
             mult_sum_2(i)<= mult_sum_1(2*i)+mult_sum_1(2*i+1);
             mult_sum_2_i(i)<= mult_sum_1_i(2*i)+mult_sum_1_i(2*i+1);           
    end generate;
    
    addergen_3 : for i in 0 to Stage_3-1 generate
        begin
             mult_sum_3(i)<=mult_sum_2(2*i)+mult_sum_2(2*i+1);
             mult_sum_3_i(i)<=mult_sum_2_i(2*i)+mult_sum_2_i(2*i+1);             
    end generate;
    
    addergen_4 : for i in 0 to Stage_4-1 generate
        begin
        mult_sum_4(i) <= mult_sum_3(2*i) + mult_sum_3(2*i+1);
        mult_sum_4_i(i) <= mult_sum_3_i(2*i) + mult_sum_3_i(2*i+1);         
    end generate;
    
    addergen_5 : for i in 0 to Stage_5-1 generate
        begin
            mult_sum_5(i) <= mult_sum_4(2*i)+mult_sum_4(2*i+1);
            mult_sum_5_i(i) <= mult_sum_4_i(2*i)+mult_sum_4_i(2*i+1);         
    end generate;
    
    addergen_6 : for i in 0 to Stage_6-1 generate
        begin
            mult_sum_6(i) <= mult_sum_5(2*i)+mult_sum_5(2*i+1);
            mult_sum_6_i(i) <= mult_sum_5_i(2*i)+mult_sum_5_i(2*i+1);            
    end generate;

-- Real Part Calculation     
    sum1 <= mult_sum_6(0) + mult_sum_6(1);
    sum2 <= sum1+bi;
    sum4 <= sum2;
    
--Imaginary Part Calculation     
    sum1_i <= mult_sum_6_i(0) + mult_sum_6_i(1);
    sum2_i <= sum1_i+bi_i;
    sum4_i <= sum2_i;
    
    
    sum_out <= sum;
    sum_out_i <= sum_i;

end Behavioral;
