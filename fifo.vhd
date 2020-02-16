library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fifo_regs is
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
    ) ;
end fifo_regs;


architecture rtl of fifo_regs is

    type t_FIFO_DATA is array(0 to g_Depth-1) of std_logic_vector(g_Width-1 downto 0);
    signal r_FIFO_DATA : t_FIFO_DATA := (others => (others => '0'));

    signal r_WR_INDEX : integer range 0 to g_Depth-1 := 0;
    signal r_RD_INDEX: integer range 0 to g_Depth-1 := 0;

    signal r_FIFO_COUNT : integer range -1 to g_Depth + 1 := 0;

    signal w_FULL : std_logic;
    signal w_EMPTY : std_logic;

begin
    process(i_clock) is
    begin
        if rising_edge(i_clock) then

            if i_reset = '1' then
                r_FIFO_COUNT <= 0;
                r_WR_INDEX <= 0;
                r_RD_INDEX <= 0;
            else
                --words in fifo
                if (i_wr_en = '1' and i_rd_en = '0') then
                    r_FIFO_COUNT <= r_FIFO_COUNT + 1;
                elsif (i_wr_en = '0' and i_rd_en = '1') then
                    r_FIFO_COUNT <= r_FIFO_COUNT - 1;
                end if;


                --write index
                if (i_wr_en= '1' and w_FULL='0') then
                    if r_WR_INDEX = g_Depth-1 then
                        r_WR_INDEX <= 0;
                    else
                        r_WR_INDEX <= r_WR_INDEX + 1;
                    end if;
                end if;


                --read index
                if(i_rd_en = '1' and w_EMPTY = '0') then
                    if r_RD_INDEX = g_Depth -1 then
                        r_RD_INDEX <= 0;
                    else
                        r_RD_INDEX <= r_RD_INDEX +1 ;
                    end if;
                end if;

                --write the data
                if i_wr_en = '1' then
                    r_FIFO_DATA(r_WR_INDEX) <= i_wr_data;
                end if;


            end if;
        end if;
    end process;

    o_rd_data <= r_FIFO_DATA(r_RD_INDEX);

    w_FULL <= '1' when r_FIFO_COUNT = g_Depth else '0';
    w_EMPTY <= '1' when r_FIFO_COUNT = 0 else '0';

    o_full <= w_Full;
    o_empty <= w_EMPTY;

end rtl ; -- rtl