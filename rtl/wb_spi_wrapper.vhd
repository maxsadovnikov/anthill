library ieee;
use ieee.std_logic_1164.all;

use work.wishbone_pkg.all;

entity wb_spi_wrapper is
  generic(
    g_interface_mode      : t_wishbone_interface_mode      := CLASSIC;
    g_address_granularity : t_wishbone_address_granularity := WORD;
    g_divider_len         : integer := 8;
    g_max_char_len        : integer := 32;
    g_num_slaves          : integer := 8
    );

  port(
    clk_sys_i : in std_logic;
    rst_n_i   : in std_logic;

    -- Wishbone
    slave_i : in  t_wishbone_slave_in;
    slave_o : out t_wishbone_slave_out;
    desc_o  : out t_wishbone_device_descriptor;

    pad_cs_o   : out std_logic_vector(g_num_slaves-1 downto 0);
    pad_sclk_o : out std_logic;
    pad_mosi_o : out std_logic;
    pad_miso_i : in  std_logic
    );

end wb_spi_wrapper;

architecture rtl of wb_spi_wrapper is

begin
  U_Wrapped_SPI: wb_spi
    generic map (
      g_interface_mode      => g_interface_mode,
      g_address_granularity => g_address_granularity,
      g_divider_len         => g_divider_len,
      g_max_char_len        => g_max_char_len,
      g_num_slaves          => g_num_slaves)
    port map (
      clk_sys_i  => clk_sys_i,
      rst_n_i    => rst_n_i,

      wb_adr_i   => slave_i.adr(4 downto 0),
      wb_dat_i   => slave_i.dat,
      wb_dat_o   => slave_o.dat,
      wb_sel_i   => slave_i.sel,
      wb_stb_i   => slave_i.stb,
      wb_cyc_i   => slave_i.cyc,
      wb_we_i    => slave_i.we,
      wb_ack_o   => slave_o.ack,
      wb_err_o   => slave_o.err,
      wb_int_o   => slave_o.int,
      wb_stall_o => slave_o.stall,

      pad_cs_o   => pad_cs_o,
      pad_sclk_o => pad_sclk_o,
      pad_mosi_o => pad_mosi_o,
      pad_miso_i => pad_miso_i);

end rtl;
