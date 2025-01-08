-- =======================================================================
-- Reset Detector (TestBench) - Proyecto Neutrinos ( ZynQ7000 AC7020C )
-- =======================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RST_DTCTR_SIM is
end RST_DTCTR_SIM;

architecture Behavioral of RST_DTCTR_SIM is

    component RST_DTCTR
        Port ( RF1 : in std_logic;  -- Senal de entrada 1
               RF2 : in std_logic;  -- Senal de entrada 2
               RF3 : in std_logic;  -- Senal de entrada 3
               ISR : out std_logic); -- Salida de interrupcion
    end component;
    
    signal s_RF1 : std_logic := '0';
    signal s_RF2 : std_logic := '0';
    signal s_RF3 : std_logic := '0';
    signal s_ISR : std_logic := '0';
    
begin

    UUT : RST_DTCTR port map (
        RF1 => s_RF1,
        RF2 => s_RF2,
        RF3 => s_RF3,
        ISR => s_ISR
    );
    
    main_process : process
    begin
 
        -- Prueba del AND
        wait for 20 ns;
        s_RF1 <= '1';
        wait for 5 ns;
        s_RF2 <= '1';
        wait for 10 ns;
        s_RF3 <= '1';
        
    end process;

end Behavioral;
