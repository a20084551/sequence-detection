module sd(
           input clk,
           input rst,
           input pattern_in,

           output reg done,
           output reg Dout
       );


enum {idle,S1,S2,S3,S4} c_state,n_state;
reg [3:0] cnt;


always@(posedge clk, posedge rst)begin 
    if(rst) begin 
        c_state <= idle;
    end else begin 
        c_state <= n_state;
    end
end

always @ (*)begin 
    case(c_state)
        idle : begin 
            if(pattern_in == 1'd1)begin 
                n_state = S1;
            end else begin 
                n_state = idle;
            end
        end

        S1 : begin 
            if(pattern_in == 1'd1)begin 
                n_state = S2;
            end else begin 
                n_state = S1;
            end
        end

        S2 : begin 
            if(pattern_in == 1'd1)begin 
                n_state = S3;
            end else begin 
                n_state = S2;
            end
        end

        S3 : begin 
            if(pattern_in == 1'd0)begin 
                n_state = S4;
            end else begin 
                n_state = S3;
            end
        end

        S4 : begin 
            if(pattern_in == 1'd1)begin 
                n_state = S2;
            end else begin 
                n_state = S4;
            end
        end

        default : begin 
            n_state = idle;
        end
    endcase
end

always @(posedge clk,posedge rst)begin 
    if(rst)begin 
        Dout <= 1'd0;
    end else begin 
        if(c_state == S4)begin 
            Dout <= 1'd1; 
        end else begin 
            Dout <= 1'd0;
        end
    end
end


/* 記得要rst，否則Dout會有unknown
always@(*)begin 
    if(rst)begin 
        Dout <= 1'd0;
    end else begin 
        case(c_state)
            S4 : begin 
                Dout = 1'd1;
            end

            default : begin 
                Dout = 1'd0;
            end
        endcase
    end
end
*/

always @ (posedge clk , posedge rst)begin 
    if(rst) begin 
        cnt <= 4'd0;
    end else begin 
        if(cnt == 14) begin 
            cnt <= 4'd0;
        end else begin 
            cnt <= cnt + 4'd1;
        end
    end
end

always @ (posedge clk , posedge rst)begin 
    if(rst) begin 
        done <= 1'd0;
    end else begin 
        if(cnt == 14)begin 
            done <= 1'd1;
        end else begin 
            done <= done;
        end
    end
end

endmodule
