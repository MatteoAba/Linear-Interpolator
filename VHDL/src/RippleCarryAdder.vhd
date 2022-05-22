library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;

---------------------------------------------------------
-- Entity
---------------------------------------------------------

entity RippleCarryAdder is
    generic (NBit : positive := 16);
    port (
        A    : in  std_logic_vector(NBit - 1 downto 0);
        B    : in  std_logic_vector(NBit - 1 downto 0);
        Cin  : in  std_logic;
        S    : out std_logic_vector(NBit - 1 downto 0);
        Cout : out std_logic
    );
end RippleCarryAdder;

---------------------------------------------------------
-- Architecture
---------------------------------------------------------

architecture rtl of RippleCarryAdder is

    -- FullAdder
    component FullAdder
        port (
            a    : in  std_logic;
            b    : in  std_logic;
            Cin  : in  std_logic;
            S    : out std_logic;
            Cout : out std_logic
        );
    end component;

    signal c_s : std_logic_vector(NBit - 1 downto 1);

begin
    -- generate NBit istances of FullAdder
    GEN: for i in 1 to NBit generate
        -- first FullAdder
        FIRST_FA: if i = 1 generate
            FA1: FullAdder port map(
                a       => A(0),
                b       => B(0),
                Cin     => Cin,
                S       => S(0),
                Cout    => c_s(1)
            );
            end generate FIRST_FA;
        
        -- FullAdders from 2 to NBit - 1
        INTERNAL_FA: if i > 1 and i < NBit generate
            FAI: FullAdder port map(
                a       => A(i-1),
                b       => B(i-1),
                Cin     => c_s(i-1),
                S       => S(i-1),
                Cout    => c_s(i)
            );
            end generate INTERNAL_FA;
        
        -- last FullAdder
        LAST_FA: if i = NBit generate
            FAN: FullAdder port map(
                a       => A(i-1),
                b       => B(i-1),
                Cin     => c_s(i-1),
                S       => S(i-1),
                Cout    => cout
            );
            end generate LAST_FA;
        end generate GEN;
end rtl;