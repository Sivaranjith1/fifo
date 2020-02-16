
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fifo_regs_tb is
end fifo_regs_tb ;

architecture behave of fifo_regs_tb is
    constant c_Depth : integer := 4;
    constant c_Width : integer := 8;

    signal r_RESET   : std_logic := '0';
    signal r_CLOCK   : std_logic := '0';
    signal r_WR_EN   : std_logic := '0';
    signal r_WR_DATA : std_logic_vector(c_WIDTH-1 downto 0) := X"A5";
    signal w_FULL    : std_logic;
    signal r_RD_EN   : std_logic := '0';
    signal w_RD_DATA : std_logic_vector(c_WIDTH-1 downto 0);
    signal w_EMPTY   : std_logic;

    component fifo_regs is
        generic (
            g_Width : natural := 8;
            g_Depth : integer := 32
        );
        port (
            i_reset : in std_logic;
            i_clock: in std_logic;

            --write
            i_wr_en : in std_logic;
            i_wr_data: in std_logic_vector(g_Width -1 downto 0);
            o_full : out std_logic;

            --read
            i_rd_en : in std_logic;
            o_rd_data : out std_logic_vector(g_Width -1 downto 0);
            o_empty : out std_logic
        );

    end component fifo_regs;

begin
    fifo_inst : fifo_regs
        generic map (
            g_Width => c_Width,
            g_Depth => c_Depth
        )
        port map (
            i_reset => r_RESET,
            i_clock => r_CLOCK,

            i_wr_en => r_WR_EN,
            i_wr_data => r_WR_DATA,
            o_full => w_FULL,
        
            i_rd_en => r_RD_EN,
            o_rd_data => w_RD_DATA,
            o_empty => w_EMPTY
        );

    r_CLOCK <= not r_CLOCK after 5 ns;

    p_TEST: process is
    begin
        wait until r_CLOCK = '1';
        r_WR_EN <= '1';
        wait until r_CLOCK = '1';
        wait until r_CLOCK = '1';
        wait until r_CLOCK = '1';
        wait until r_CLOCK = '1';
        r_WR_EN <= '0';
        r_RD_EN <= '1';
        wait until r_CLOCK = '1';
        wait until r_CLOCK = '1';
        wait until r_CLOCK = '1';
        wait until r_CLOCK = '1';
        r_RD_EN <= '0';
        r_WR_EN <= '1';
        wait until r_CLOCK = '1';
        wait until r_CLOCK = '1';
        r_RD_EN <= '1';
        wait until r_CLOCK = '1';
        wait until r_CLOCK = '1';
        wait until r_CLOCK = '1';
        wait until r_CLOCK = '1';
        r_WR_EN <= '0';
        r_RD_EN <= '0';
        
    end process p_TEST;


end architecture ; -- behave