library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.nn_package.all;

entity nn is
    Port (
        clk: in std_logic;
        x_in: in batch_x_array;
        x_in_imag: in batch_x_array;
        y_out: out y_array;
        y_out_imag: out y_array);
end nn;

architecture Behavioral of nn is

    -- Component declarations
    component n_hidden
        port (
            clk : in std_logic;
            x,x_i, w, w_i : in x_array;
            bi, bi_i : in signed(N-1 downto 0);
            sum_out : out signed(N-1 downto 0);
            sum_out_i : out signed(N-1 downto 0));
    end component;

    component n_output
        port (
            clk : in std_logic;
            x,x_i, w,w_i : in a_array;
            bi,bi_i : in signed(N-1 downto 0);
            sum_out : out signed(N-1 downto 0);
            sum_out_i : out signed(N-1 downto 0));
    end component;

    component input_processing
        port (
            clk : in std_logic;
            x : in x_array;
            p1, p2, p3 : in p1_array;
            x_norm : out x_array);
    end component;

    component output_processing
        port (
            clk : in std_logic;
            y_norm : in y_array;
            p1, p2, p3 : in p2_array;
            y : out y_array);
    end component;

    component tansig
        port (
            clk : in std_logic;
            x : in signed(N-1 downto 0);
            x_i : in signed(N-1 downto 0);
            y : out signed(N-1 downto 0);
            y_i : out signed(N-1 downto 0));
    end component;

    component purelin
        port (
            clk : in std_logic;
            x : in signed(N-1 downto 0);
            y : out signed(N-1 downto 0));
    end component;
    
    component softmax
        port ( x_real : in signed (N-1 downto 0);
               x_imag : in signed (N-1 downto 0);
               y_real : out signed (N-1 downto 0);
               y_imag : out signed (N-1 downto 0));
    end component;


    -- Intermediate signal declarations
    signal b1 : b1_array;
    signal b1_i : b1_array;
    signal w1 : w1_array;
    signal w1_i : w1_array;
    signal sum1 : sum1_array;
    signal sum1_i : sum1_array;
    signal a1 : a_array;
    signal a1_i : a_array;
    signal b2 : b2_array;
    signal b2_i : b2_array;
    signal w2 : w2_array;
    signal w2_i : w2_array;
    signal sum2 : sum2_array;
    signal sum2_i : sum2_array;
    
    signal p11, p12, p13 : p1_array;
    signal p21, p22, p23 : p2_array;
    
    signal x, x_norm, x_temp_real : x_array;
    signal x_i, x_temp_imag : x_array;
    signal y, y_norm : y_array;
    signal y_i : y_array;
    
    signal stage_1_x_real : batch_x_array;
    signal stage_2_x_real : batch_x_array;
    signal stage_3_x_real : batch_x_array;
    signal stage_4_x_real : batch_x_array;
    signal stage_5_x_real : batch_x_array;
    signal stage_6_x_real : batch_x_array;
    signal stage_7_x_real : batch_x_array;
    signal stage_8_x_real : batch_x_array;
    
    signal stage_1_x_real_reg : batch_x_array;
    signal stage_2_x_real_reg : batch_x_array;
    signal stage_3_x_real_reg : batch_x_array;
    signal stage_4_x_real_reg : batch_x_array;
    signal stage_5_x_real_reg : batch_x_array;
    signal stage_6_x_real_reg : batch_x_array;
    signal stage_7_x_real_reg : batch_x_array;
    signal stage_8_x_real_reg : batch_x_array;
    
    signal stage_1_x_imag : batch_x_array;
    signal stage_2_x_imag : batch_x_array;
    signal stage_3_x_imag : batch_x_array;
    signal stage_4_x_imag : batch_x_array;
    signal stage_5_x_imag : batch_x_array;
    signal stage_6_x_imag : batch_x_array;
    signal stage_7_x_imag : batch_x_array;
    signal stage_8_x_imag : batch_x_array;
    
    signal stage_1_x_imag_reg : batch_x_array;
    signal stage_2_x_imag_reg : batch_x_array;
    signal stage_3_x_imag_reg : batch_x_array;
    signal stage_4_x_imag_reg : batch_x_array;
    signal stage_5_x_imag_reg : batch_x_array;
    signal stage_6_x_imag_reg : batch_x_array;
    signal stage_7_x_imag_reg : batch_x_array;
    signal stage_8_x_imag_reg : batch_x_array;

begin

--    -- Generate signed parameter arrays for input processing
--    P1GEN: for i in 0 to NUM_X-1 generate
--    begin
--        p11(i) <= to_signed(integer(p11r(i)*ONE),N);
--        p12(i) <= to_signed(integer(p12r(i)*ONE),N);
--        p13(i) <= to_signed(integer(p13r(i)*ONE),N);
--    end generate;

--    -- Generate signed parameter arrays for output processing
--    P2GEN: for i in 0 to NUM_Y-1 generate
--    begin
--        p21(i) <= to_signed(integer(p21r(i)*ONE),N);
--        p22(i) <= to_signed(integer(p22r(i)*ONE),N);
--        p23(i) <= to_signed(integer(p23r(i)*ONE),N);
--    end generate;

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

--    -- Input processing
--    process_input_unit: input_processing
--        port map (	clk=>clk,
--                 x=>x,
--                 p1=>p11,
--                 p2=>p12,
--                 p3=>p13,
--                 x_norm=>x_norm
--                );

    -- Hidden layer neurons
    L1GEN: for j in 0 to NUM_L1-1 generate
    begin
        tansig_unit: n_hidden
            port map (
                clk=>clk,
                x=>x,
                x_i=>x_i,
                w=>w1(j),
                w_i=>w1_i(j),
                bi=>b1(j),
                bi_i=>b1_i(j),
                sum_out=>sum1(j),
                sum_out_i=>sum1_i(j)
            );
    end generate;

        -- Tansig transfer function for hidden layer
        TF1GEN: for i in 0 to NUM_L1-1 generate
        begin
    	tansig_unit: tansig
    	            port map (
    							clk=>clk,
    							x=>sum1(i),
    							x_i=>sum1_i(i), 
    							y=>a1(i),
    							y_i=>a1_i(i)
    						);
    	            end generate;

        -- Output layer neurons
        L2GEN: for i in 0 to NUM_Y-1 generate
        begin
            output_unit: n_output
            port map (
    					clk=>clk,
    					x=>a1,
    					x_i=>a1_i, 
    					w=>w2(i),
    					w_i=>w2_i(i),
    					bi=>b2(i),
    					bi_i=>b2_i(i), 
    					sum_out=>sum2(i),
    					sum_out_i=>sum2_i(i)
    				);
            end generate;

        -- Purelin transfer function for output layer
        TF2GEN: for i in 0 to NUM_Y-1 generate
        begin
            softmax_unit: softmax
            port map (
    					x_real=>sum2(i),
                        x_imag=>sum2_i(i),
                        y_real => y(i),
                        y_imag => y_i(i)
    				);
            end generate;

    --    -- Output Processing
    --    process_output_unit: output_processing
    --    port map (
    --				clk=>clk,
    --				y_norm=>y_norm,
    --				p1=> p21,
    --				p2=> p22,
    --				p3=> p23,
    --				y=> y
    --			);
    
    stage_1_x_real <= x_in;
    stage_2_x_real <= stage_1_x_real_reg; 
    stage_3_x_real <= stage_2_x_real_reg;
    stage_4_x_real <= stage_3_x_real_reg; 
    stage_5_x_real <= stage_4_x_real_reg;
    stage_6_x_real <= stage_5_x_real_reg; 
    stage_7_x_real <= stage_6_x_real_reg;
    stage_8_x_real <= stage_7_x_real_reg;
    
    stage_1_x_imag <= x_in_imag;
    stage_2_x_imag <= stage_1_x_imag_reg; 
    stage_3_x_imag <= stage_2_x_imag_reg;
    stage_4_x_imag <= stage_3_x_imag_reg; 
    stage_5_x_imag <= stage_4_x_imag_reg;
    stage_6_x_imag <= stage_5_x_imag_reg; 
    stage_7_x_imag <= stage_6_x_imag_reg;
    stage_8_x_imag <= stage_7_x_imag_reg;
    
    inputGen_1 : for i in 0 to BATCH_SIZE-1 generate
        begin
            x_temp_real(0*BATCH_SIZE+i) <= stage_8_x_real(i);
            x_temp_imag(0*BATCH_SIZE+i) <= stage_8_x_imag(i);
    end generate;
    
    inputGen_2 : for i in 0 to BATCH_SIZE-1 generate
        begin
            x_temp_real(1*BATCH_SIZE+i) <= stage_7_x_real(i);
            x_temp_imag(1*BATCH_SIZE+i) <= stage_7_x_imag(i);
    end generate;
    
    inputGen_3 : for i in 0 to BATCH_SIZE-1 generate
        begin
            x_temp_real(2*BATCH_SIZE+i) <= stage_6_x_real(i);
            x_temp_imag(2*BATCH_SIZE+i) <= stage_6_x_imag(i);
    end generate;
    
    inputGen_4 : for i in 0 to BATCH_SIZE-1 generate
        begin
            x_temp_real(3*BATCH_SIZE+i) <= stage_5_x_real(i);
            x_temp_imag(3*BATCH_SIZE+i) <= stage_5_x_imag(i);
    end generate;
    
    inputGen_5 : for i in 0 to BATCH_SIZE-1 generate
        begin
            x_temp_real(4*BATCH_SIZE+i) <= stage_4_x_real(i);
            x_temp_imag(4*BATCH_SIZE+i) <= stage_4_x_imag(i);
    end generate;
    
    inputGen_6 : for i in 0 to BATCH_SIZE-1 generate
        begin
            x_temp_real(5*BATCH_SIZE+i) <= stage_3_x_real(i);
            x_temp_imag(5*BATCH_SIZE+i) <= stage_3_x_imag(i);
    end generate;
    
    inputGen_7 : for i in 0 to BATCH_SIZE-1 generate
        begin
            x_temp_real(6*BATCH_SIZE+i) <= stage_2_x_real(i);
            x_temp_imag(6*BATCH_SIZE+i) <= stage_2_x_imag(i);
    end generate;
    
    inputGen_8 : for i in 0 to BATCH_SIZE-1 generate
        begin
            x_temp_real(7*BATCH_SIZE+i) <= stage_1_x_real(i);
            x_temp_imag(7*BATCH_SIZE+i) <= stage_1_x_imag(i);
    end generate;
    
    process(clk)
    begin
        if (rising_edge(clk))then
            x <= x_temp_real;
            x_i <= x_temp_imag;
            y_out <= y;
            y_out_imag <= y_i;
            
            stage_1_x_real_reg <= stage_1_x_real;
            stage_2_x_real_reg <= stage_2_x_real;
            stage_3_x_real_reg <= stage_3_x_real;
            stage_4_x_real_reg <= stage_4_x_real;
            stage_5_x_real_reg <= stage_5_x_real;
            stage_6_x_real_reg <= stage_6_x_real;
            stage_7_x_real_reg <= stage_7_x_real;
            stage_8_x_real_reg <= stage_8_x_real;
            
            stage_1_x_imag_reg <= stage_1_x_imag;
            stage_2_x_imag_reg <= stage_2_x_imag;
            stage_3_x_imag_reg <= stage_3_x_imag;
            stage_4_x_imag_reg <= stage_4_x_imag;
            stage_5_x_imag_reg <= stage_5_x_imag;
            stage_6_x_imag_reg <= stage_6_x_imag;
            stage_7_x_imag_reg <= stage_7_x_imag;
            stage_8_x_imag_reg <= stage_8_x_imag;
            
        end if;
    end process;
end Behavioral;
