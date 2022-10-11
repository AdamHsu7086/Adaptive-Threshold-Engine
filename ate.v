module ate(clk,reset,pix_data,bin,threshold);
input clk;
input reset;
input [7:0] pix_data;
output reg bin;
output reg [7:0] threshold;
reg [4:0] block;
reg [7:0] min;
reg [7:0] max;
reg [5:0] count;
reg [7:0] buffer [0:63];

always@(*)begin //max
  if(count  == 1)
    max = pix_data;
  else if(pix_data >= max)
    max = pix_data;
  else
    max = max;
end

always@(*)begin //min
  if(count == 1)
    min = pix_data;
  else if(pix_data <= min)
    min = pix_data;
  else
    min = min;
end

always@(posedge clk or posedge reset)begin //threshold
  if(reset)
    threshold <= 0;
  else if((block % 6 == 1) || (block % 6 == 0))
    threshold <= 0;
  else if((count == 0) && ((max + min) % 2 == 0))
    threshold <= (max + min) / 2;
  else if((count== 0) && ((max + min) % 2 != 0))
    threshold <= ((max + min) / 2 ) + 1;
end

always@(posedge clk or posedge reset)begin //block
  if(reset)
    block <= 0;
  else if(count == 63)
    block <= block + 1;
end

always@(posedge clk or posedge reset)begin //count
  if(reset)
    count <= 0;
  else if(reset == 0)
    count <= count + 1;  
end

always@(posedge clk or posedge reset)begin //buffer
  if(reset)
    buffer[count] <= 0;
  else if(reset == 0)
    buffer[count] <= pix_data;
end


always@(posedge clk or posedge reset)begin
  if(reset)
    bin <= 0;
  else if((block % 6 == 1) || (block % 6 == 0))
    bin <= 0;
  else if((count == 0) && ((buffer[count]) <  ((max + min)/2)))
    bin <= 0;
  else if((count == 0) && ((buffer[count]) >= ((max + min)/2)))
    bin <= 1;
  else if((count > 0) && (buffer[count] < threshold))
    bin <= 0;
  else if((count > 0) && (buffer[count] >= threshold))
    bin <= 1;
end


endmodule








