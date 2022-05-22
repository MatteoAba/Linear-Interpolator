library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;

---------------------------------------------------------
-- Entity
---------------------------------------------------------

entity counter is
    generic (NBit : positive := 2);
    port (
        clk     : in  std_logic;
        a_rst_n : in  std_logic;
        dout    : out std_logic_vector(NBit - 1 downto 0)
    );
end counter;

---------------------------------------------------------
-- Architecture
---------------------------------------------------------

architecture rtl of counter is
    -- signals
    signal rca_s    : std_logic_vector(NBit - 1 downto 0);
    signal dout_s   : std_logic_vector(NBit - 1 downto 0);
    
    -- constants
    constant zero   : std_logic := '0';
    constant one    : std_logic := '1';
    constant one_v  : std_logic_vector(1 downto 0) := "01";

    -- DFF for counting
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

    -- RCA for the increment
    component RippleCarryAdder
        generic (NBit : positive := 16);
        port (
            A    : in  std_logic_vector(NBit - 1 downto 0);
            B    : in  std_logic_vector(NBit - 1 downto 0);
            Cin  : in  std_logic;
            S    : out std_logic_vector(NBit - 1 downto 0);
            Cout : out std_logic
        );
    end component;

begin
    -- rca_s <= dout_s + one_v;
    RCA: RippleCarryAdder
        generic map (NBit => NBit)
        port map(
            a       => dout_s,
            b       => one_v,
            Cin     => zero,
            s       => rca_s
        );

    -- flip flop
    REG: DFF_N
        generic map (NBit => NBit)
        port map(
            clk     => clk,   
            a_rst_n => a_rst_n,
            en      => one,
            D       => rca_s,
            Q       => dout_s
        );

    -- continuos assignment for the output
    dout  <= dout_s;
end rtl;