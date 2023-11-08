library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.nn_package.all;

entity n_output is
    Port ( 
        clk : in std_logic;
        x,x_i, w, w_i : in a_array;
        bi, bi_i : in signed(N-1 downto 0);
        sum_out : out signed(N-1 downto 0);
        sum_out_i : out signed(N-1 downto 0));
end n_output;

architecture Behavioral of n_output is
component mult is
    port ( a : in SIGNED (N-1 downto 0);
           b : in SIGNED (N-1 downto 0);
           c : out SIGNED (N-1 downto 0)--;
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
    constant Stage_1 : integer := 10;
    constant Stage_2 : integer := 5;
    constant Stage_3 : integer := 2;
    
    type a_array_Stage_1 is array(0 to Stage_1-1) of signed(N-1 downto 0); -- Array of hidden activation function 
    type a_array_Stage_2 is array(0 to Stage_2-1) of signed(N-1 downto 0);
    type a_array_Stage_3 is array(0 to Stage_3-1) of signed(N-1 downto 0);
    
    signal mult_sum_1_i : a_array_Stage_1;
    signal mult_sum_2_i : a_array_Stage_2;
    signal mult_sum_3_i : a_array_Stage_3;
    
    signal mult_sum_1 : a_array_Stage_1;
    signal mult_sum_2 : a_array_Stage_2;
    signal mult_sum_3 : a_array_Stage_3;
    
    signal sum_i_1, sum_i_2, sum_i_3, sum_i_4 : signed(N-1 downto 0);
    signal sum_r_1, sum_r_2, sum_r_3, sum_r_4 : signed(N-1 downto 0);


    signal mult_array : a_array;
    signal mult_array_i : a_array;
    signal sum : signed(N-1 downto 0);
    signal sum_i : signed(N-1 downto 0);
    signal bi_1 : signed(N-1 downto 0);
    
--    signal sum1_1, sum1_2, sum1_3, sum1_4, sum1_5, sum1_6, sum1_7, sum1_8, sum1_9, sum1_10, sum1_11, sum1_12, sum1_13, sum1_14, sum1_15, sum1_16: signed(N-1 downto 0);
--    signal sum2_1, sum2_2, sum2_3, sum2_4, sum2_5, sum2_6, sum2_7, sum2_8: signed(N-1 downto 0);
--    signal sum3_1, sum3_2, sum3_3, sum3_4: signed(N-1 downto 0);
--    signal sum4_1, sum4_2 : signed(N-1 downto 0);
--    signal sum4:signed(N-1 downto 0);

begin
process(clk)
begin
    if (rising_edge(clk))then
        sum <= sum_r_4;
        bi_1<=bi;
        
        sum_i <= sum_i_4;
        end if;
    end process;
	
    -- Multiply each input with its corresponding weight
    -- YOUR CODE HERE
	multgen : for i in 0 to NUM_L1-1 generate
            begin
                mult_unit: mult_complex
                port map (
							--clk=>clk,
                            a_real=>x(i),
                            a_imag=>x_i(i), 
                            b_real=>w(i), 
                            b_imag=>w_i(i), 
                            c_real=>mult_array(i),
                            c_imag=>mult_array_i(i)
                          );
            end generate;

    
--    -- Sum the products and bias
--    -- YOUR CODE HERE
--	sum1_1 <= mult_array(0)+mult_array(1);
--	sum1_2 <= mult_array(2)+mult_array(3);
--	sum1_3 <= mult_array(4)+mult_array(5);
--	sum1_4 <= mult_array(6)+mult_array(7);
--	sum1_5 <= mult_array(8)+mult_array(9);
--	sum1_6 <= mult_array(10)+mult_array(11);
--	sum1_7 <= mult_array(12)+mult_array(13);
--	sum1_8 <= mult_array(14)+mult_array(15);
--	sum1_9 <= mult_array(16)+mult_array(17);
--	sum1_10 <= mult_array(18)+mult_array(19);
--	sum1_11 <= mult_array(20)+mult_array(21);
--	sum1_12 <= mult_array(22)+mult_array(23);
--	sum1_13 <= mult_array(24)+bi;
--	--sum1_14 <= mult_array(26)+mult_array(27);
--	--sum1_15 <= mult_array(28)+mult_array(29);
--	--sum1_16 <= bi;
	
--	sum2_1 <= sum1_1+sum1_2;
--	sum2_2 <= sum1_3+sum1_4;
--	sum2_3 <= sum1_5+sum1_6;
--	sum2_4 <= sum1_7+sum1_8;
--	sum2_5 <= sum1_9+sum1_10;
--	sum2_6 <= sum1_11+sum1_12;
--	sum2_7 <= sum1_13; -- +sum1_14;
--	--sum2_8 <= sum1_15+sum1_16;
	
--	sum3_1 <= sum2_1 + sum2_2;
--	sum3_2 <= sum2_3 + sum2_4;
--	sum3_3 <= sum2_5 + sum2_6;
--	sum3_4 <= sum2_7 ; --+ sum2_8;
	
--	sum4_1 <= sum3_1 + sum3_2;
--	sum4_2 <= sum3_3 + sum3_4;
	
--	sum4   <=  sum4_1 + sum4_2; 
	
	
-- real part calculation 	
	addergen_1 : for i in 0 to Stage_1-1 generate
        begin
            adder_unit : adder
                port map (
                    A=>mult_array(2*i),
                    B=> mult_array(2*i+1),
                    C=>mult_sum_1(i)
                );             
    end generate;
    
    addergen_2 : for i in 0 to Stage_2-1 generate
        begin
            adder_unit : adder
                port map (
                    A=>mult_sum_1(2*i),
                    B=> mult_sum_1(2*i+1),
                    C=>mult_sum_2(i)
                );             
    end generate;
    
    
    addergen_3 : for i in 0 to Stage_3-1 generate
        begin
            adder_unit : adder
                port map (
                    A=>mult_sum_2(2*i),
                    B=> mult_sum_2(2*i+1),
                    C=>mult_sum_3(i)
                );             
    end generate;
    
    sum_r_1 <= mult_sum_3(0)+mult_sum_3(1);
    sum_r_2 <= mult_sum_2(4);
    
    sum_r_3 <= sum_r_1+sum_r_2;
    sum_r_4 <= sum_r_3+bi;
	

-- Imaginary Part Calculation	
    addergen_i_1 : for i in 0 to Stage_1-1 generate
        begin
            adder_unit : adder
                port map (
                    A=>mult_array_i(2*i),
                    B=> mult_array_i(2*i+1),
                    C=>mult_sum_1_i(i)
                );             
    end generate;
    
    addergen_i_2 : for i in 0 to Stage_2-1 generate
        begin
            adder_unit : adder
                port map (
                    A=>mult_sum_1_i(2*i),
                    B=> mult_sum_1_i(2*i+1),
                    C=>mult_sum_2_i(i)
                );             
    end generate;
    
    addergen_i_3 : for i in 0 to Stage_3-1 generate
        begin
            adder_unit : adder
                port map (
                    A=>mult_sum_2_i(2*i),
                    B=> mult_sum_2_i(2*i+1),
                    C=>mult_sum_3_i(i)
                );             
    end generate;
    
    sum_i_1 <= mult_sum_3_i(0)+mult_sum_3_i(1);
    sum_i_2 <= mult_sum_2_i(4);
    
    sum_i_3 <= sum_i_1+sum_i_2;
    sum_i_4 <= sum_i_3 + bi_i;
    
    
    
    sum_out <= resize(sum, N);
    sum_out_i <= resize(sum_i, N);

end Behavioral;