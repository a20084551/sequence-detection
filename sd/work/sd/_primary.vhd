library verilog;
use verilog.vl_types.all;
entity sd is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        pattern_in      : in     vl_logic;
        done            : out    vl_logic;
        Dout            : out    vl_logic
    );
end sd;
