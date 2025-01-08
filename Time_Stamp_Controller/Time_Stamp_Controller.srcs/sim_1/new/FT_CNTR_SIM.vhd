-- =======================================================================
-- Fine Time Counter (TestBench) - Proyecto Neutrinos ( ZynQ7000 AC7020C )
-- =======================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FT_CNTR_SIM is
end FT_CNTR_SIM;

architecture Behavioral of FT_CNTR_SIM is

    component FT_CNTR
        port ( CLK : in std_logic;                              -- Clock
               EN  : in std_logic;                              -- Enable
               RST : in std_logic;                              -- Reset
               ISR : in std_logic;                              -- Interruptor de cuenta
               CNT : out std_logic_vector ( 31 downto 0 ) );    -- Salida con la cuenta
    end component;
    
    signal s_CLK : std_logic := '0';
    signal s_EN  : std_logic := '0';
    signal s_RST : std_logic := '0';
    signal s_ISR : std_logic := '0';
    signal s_CNT : std_logic_vector ( 31 downto 0 ) := ( others => '0' );
    
    constant clk_period : time := 20 ns;

begin

    UUT : FT_CNTR port map (
        CLK => s_CLK,
        EN  => s_EN,
        RST => s_RST,
        ISR => s_ISR,
        CNT => s_CNT
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
 
        -- Habilita
        wait for 20 ns;
        s_EN <= '1';
        
        -- Prueba 1 (1 ms = 50 000 cuentas)
        -- wait for 1 ms;
        -- s_ISR <= '1';
        -- wait for 50 us;
        -- s_ISR <= '0';
        
        -- Prueba 2 (20 ms = 1 000 000 000)
        wait for 20 ms;
        s_ISR <= '1';
        wait for 50 us;
        s_ISR <= '0';
        
    end process;

end Behavioral;
