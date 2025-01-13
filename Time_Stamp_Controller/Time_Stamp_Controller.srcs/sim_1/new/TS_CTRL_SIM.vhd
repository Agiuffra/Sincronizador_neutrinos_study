-- =======================================================================
-- Time Stamp Controller (TestBench) - Proyecto Neutrinos ( ZynQ7000 AC7020C )
-- =======================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TS_CTRL_SIM is
end TS_CTRL_SIM;

architecture Behavioral of TS_CTRL_SIM is

    component TS_CTRL is
    Port ( 
        CLK         : in std_logic;         -- Clock
        S1, S2, S3  : in std_logic;         -- Senales de interrupcion
        UART_TX_o   : out std_logic;        -- Salida UART serial
        LED1        : out std_logic := '0'  -- LED embebido para debug
    );
    end component;
    
    signal s_CLK, s_S1, s_S2, s_S3, s_UART_TX_o, s_LED1 : std_logic := '0';
    constant clk_period : time := 20 ns;

begin

    UUT : TS_CTRL port map (
        CLK => s_CLK,
        S1 => s_S1,
        S2 => s_S2,
        S3 => s_S3,
        UART_TX_o => s_UART_TX_o,
        LED1 => s_LED1 
    );
    
    clk_process : process
    begin
        s_CLK <= '0';
        wait for clk_period/2;
        s_CLK <= '1';
        wait for clk_period/2;
    end process;
    
    main_process : process
    begin
 
        -- Prueba del AND
        wait for 500 ms;
        s_S1 <= '1';
        s_S2 <= '1';
        s_S3 <= '1';
        wait for 20 ms;
        s_S1 <= '0';
        s_S2 <= '0';
        s_S3 <= '0';
        
        
    end process;

end Behavioral;
