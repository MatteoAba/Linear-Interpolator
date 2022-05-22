library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;

---------------------------------------------------------
-- Entity
---------------------------------------------------------

entity CombInterpolation is
    generic (NBit : positive := 16);
    port (
        ni      : in  std_logic_vector(NBit - 1 downto 0);
        oi      : in  std_logic_vector(NBit - 1 downto 0);
        out0    : out std_logic_vector(NBit - 1 downto 0);
        out1    : out std_logic_vector(NBit - 1 downto 0);
        out2    : out std_logic_vector(NBit - 1 downto 0);
        out3    : out std_logic_vector(NBit - 1 downto 0)
    );
end CombInterpolation;

---------------------------------------------------------
-- Architecture
---------------------------------------------------------

architecture rtl of CombInterpolation is 

    -- constant
    constant zero   : std_logic := '0';

    -- signals
    signal ni_d2_s      : std_logic_vector(NBit - 1 downto 0);
    signal ni_d4_s      : std_logic_vector(NBit - 1 downto 0);
    signal oi_d2_s      : std_logic_vector(NBit - 1 downto 0);
    signal oi_d4_s      : std_logic_vector(NBit - 1 downto 0);
    signal rca_1_out_s  : std_logic_vector(NBit - 1 downto 0);
    signal rca_4_out_s  : std_logic_vector(NBit - 1 downto 0);

    -- RCA for the sums 
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

    -----------------------
    -- signal assignment --
    -----------------------

    -- ni_d2_s = ni/2 (ni right shift of 1)
    ni_d2_s(NBit - 1) <= '0';
    ni_d2_s(NBit - 2 downto 0) <= ni(NBit - 1 downto 1);

    -- ni_d4_s = ni/4 (ni right shift of 2)
    ni_d4_s(NBit - 1 downto NBit - 2) <= (others => '0');
    ni_d4_s(NBit - 3 downto 0) <= ni(NBit - 1 downto 2);

    -- oi_d2_s = oi/2 (oi right shift of 1)
    oi_d2_s(NBit - 1) <= '0';
    oi_d2_s(NBit - 2 downto 0) <= oi(NBit - 1 downto 1);

    -- oi_d4_s = oi/4 (oi right shift of 2)
    oi_d4_s(NBit - 1 downto NBit - 2) <= (others => '0');
    oi_d4_s(NBit - 3 downto 0) <= oi(NBit - 1 downto 2);

    ----------
    -- OUT0 --      out0 = oi
    ----------

    out0 <= oi;

    ----------
    -- OUT1 --      out1 = ni_d4_s + oi_d4_s + oi_d2_s
    ----------

    RCA_1: RippleCarryAdder
        generic map (NBit => NBit)
        port map(
            A       => ni_d4_s,
            B       => oi_d4_s,
            Cin     => zero,
            S       => rca_1_out_s
        );

    RCA_2: RippleCarryAdder
        generic map (NBit => NBit)
        port map(
            a       => oi_d2_s,
            b       => rca_1_out_s,
            Cin     => zero,
            s       => out1
        );
    
    ----------
    -- OUT2 --      out2 = ni_d2_s + oi_d2_s
    ----------

    RCA_3: RippleCarryAdder
        generic map (NBit => NBit)
        port map(
            a       => ni_d2_s,
            b       => oi_d2_s,
            Cin     => zero,
            s       => out2
        );
    
    ----------
    -- OUT3 --      out3 = ni_d4_s + ni_d2_s + oi_d4_s
    ----------
    
    RCA_4: RippleCarryAdder
        generic map (NBit => NBit)
        port map(
            a       => ni_d4_s,
            b       => ni_d2_s,
            Cin     => zero,
            s       => rca_4_out_s
        );

    RCA_5: RippleCarryAdder
        generic map (NBit => NBit)
        port map(
            a       => oi_d4_s,
            b       => rca_4_out_s,
            Cin     => zero,
            s       => out3
        );

end rtl;