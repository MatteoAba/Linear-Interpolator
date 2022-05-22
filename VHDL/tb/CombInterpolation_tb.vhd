library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity CombInterpolation_tb is
    end CombInterpolation_tb;

architecture rtl of CombInterpolation_tb is

    constant clk_period     : time := 100 ns;
    constant NBit           : positive := 16;

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

    signal clk          : std_logic := '0';
    signal ni_ext       : std_logic_vector(NBit - 1 downto 0) := (others => '0');
    signal oi_ext       : std_logic_vector(NBit - 1 downto 0) := (others => '0');
    signal out0_ext     : std_logic_vector(NBit - 1 downto 0);
    signal out1_ext     : std_logic_vector(NBit - 1 downto 0);
    signal out2_ext     : std_logic_vector(NBit - 1 downto 0);
    signal out3_ext     : std_logic_vector(NBit - 1 downto 0);
    signal testing      : boolean := true;
    
    begin
        clk <= not clk after clk_period/2 when testing else '0';

        dut: CombInterpolation
        generic map (NBit => NBit)
        port map(
            ni  => ni_ext,
            oi  => oi_ext,  
            out0 => out0_ext,
            out1 => out1_ext,
            out2 => out2_ext,
            out3 => out3_ext
        );

        stimulus : process 
			begin            -- 73 -> 88
			oi_ext <= x"0049";
            ni_ext <= x"0058";
			wait for 500 ns; -- 89 -> 93
			oi_ext <= x"0059";
            ni_ext <= x"005D";
			wait for 500 ns; -- 67 -> 55
			oi_ext <= x"0043";
            ni_ext <= x"0037";
			wait for 500 ns; -- 82 -> 41
			oi_ext <= x"0052";
            ni_ext <= x"0029";
            wait for 500 ns; -- 41 -> 41 (same signal)
			oi_ext <= x"0029";
            ni_ext <= x"0029";
			wait for 500 ns; -- Limit Case 
			oi_ext <= x"FFFF";
            ni_ext <= x"FFFF";
			wait for 500 ns;
			testing  <= false;
		end process;
end rtl;