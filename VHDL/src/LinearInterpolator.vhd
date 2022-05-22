library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;

---------------------------------------------------------
-- Entity
---------------------------------------------------------

entity LinearInterpolator is
    generic (NBit : positive := 16);
    port (
        clk         : in  std_logic;
		a_rst_n     : in  std_logic;
    	signal_in   : in  std_logic_vector(NBit - 1 downto 0);
		signal_out  : out std_logic_vector(NBit - 1 downto 0)
    );
end LinearInterpolator;

---------------------------------------------------------
-- Architecture
---------------------------------------------------------

architecture rtl of LinearInterpolator is
    -- signals
    signal ctr_out_s    : std_logic_vector(1 downto 0);
    signal reg_ni_s     : std_logic_vector(NBit - 1 downto 0);
    signal reg_oi_s     : std_logic_vector(NBit - 1 downto 0);
    signal and_out_s    : std_logic;
    signal ci_out_0_s   : std_logic_vector(NBit - 1 downto 0);
    signal ci_out_1_s   : std_logic_vector(NBit - 1 downto 0);
    signal ci_out_2_s   : std_logic_vector(NBit - 1 downto 0);
    signal ci_out_3_s   : std_logic_vector(NBit - 1 downto 0);
    signal mux_to_reg_s : std_logic_vector(NBit - 1 downto 0);

    -- constant
    constant one    : std_logic := '1';

    component DFF_N
        generic (NBit : positive := 16);
        port (
            clk     : in  std_logic;
            a_rst_n : in  std_logic;
            en      : in  std_logic;
            D       : in  std_logic_vector(NBit - 1 downto 0);
            Q       : out std_logic_vector(NBit - 1 downto 0)
        );
        end component;

    component counter
        generic (NBit : positive := 2);
        port (
            clk     : in  std_logic;
            a_rst_n : in  std_logic;
            dout    : out std_logic_vector(NBit - 1 downto 0)
        );
        end component;

    component CombInterpolation
        generic (NBit : positive := 16);
        port (
            ni      : in  std_logic_vector(NBit - 1 downto 0);
            oi      : in  std_logic_vector(NBit - 1 downto 0);
            out0    : out std_logic_vector(NBit - 1 downto 0);
            out1    : out std_logic_vector(NBit - 1 downto 0);
            out2    : out std_logic_vector(NBit - 1 downto 0);
            out3    : out std_logic_vector(NBit - 1 downto 0)
        );
    end component;

begin

    and_out_s <= ctr_out_s(0) and ctr_out_s(1);

    -- new input
    REG_NI: DFF_N
        generic map (NBit => NBit)
        port map(
            clk     => clk,   
            a_rst_n => a_rst_n,
            en      => and_out_s,
            D       => signal_in,
            Q       => reg_ni_s
        );

    -- old input
    REG_OI: DFF_N
        generic map (NBit => NBit)
        port map(
            clk     => clk,   
            a_rst_n => a_rst_n,
            en      => and_out_s,
            D       => reg_ni_s,
            Q       => reg_oi_s
        );

    -- counter to control DFFs' activation
    COUNTER_1: counter
        generic map (NBit => 2)
        port map(
            clk     => clk,
            a_rst_n => a_rst_n,
            dout    => ctr_out_s
        );

    -- combinatorial interpolator for new input and old input
    CI: CombInterpolation
        generic map (NBit => Nbit)
        port map(
            ni      => reg_ni_s,
            oi      => reg_oi_s,
            out0    => ci_out_0_s,
            out1    => ci_out_1_s,
            out2    => ci_out_2_s,
            out3    => ci_out_3_s
        );

    -- multiplexer for the output
    MUX: process(ctr_out_s, ci_out_0_s, ci_out_1_s, ci_out_2_s, ci_out_3_s)
    begin
        case ctr_out_s is
            when "00" => mux_to_reg_s <= ci_out_0_s;
            when "01" => mux_to_reg_s <= ci_out_1_s;
            when "10" => mux_to_reg_s <= ci_out_2_s;
            when "11" => mux_to_reg_s <= ci_out_3_s;
            when others => mux_to_reg_s <= (others => '0');
        end case;
    end process;

    -- DFF for the output
    REG_OUT: DFF_N
    generic map (NBit => NBit)
    port map(
        clk     => clk,   
        a_rst_n => a_rst_n,
        en      => one,
        D       => mux_to_reg_s,
        Q       => signal_out
    );

end rtl;