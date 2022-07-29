function CC_string = Generate_CCX(NetListPath)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%    Inputs = [1,1,1,1,1,1,0,0,0,0,0,0,0,0];
%    gate_type = [1,2,1,1,2,1,2,2];
%    Label = ['abcdefghijklmn'];


fID  = fopen(NetListPath,'r');

Inputs = [];
gate = 1;
newnode_ind = 1;
Nodes = {};
gate_type = {};
G = [];

tline = fgetl(fID);
while ischar(tline)
    element = strsplit(tline);
    gate_type{gate} = element{1};
    [d , element_words] = size(element);
    out_node_label = element{element_words};
    
    %Process and insert output node in the matrix G and in Nodes
    out_ind = find(ismember(Nodes,out_node_label));
    [d , found ] = size(out_ind);
    if (found == 0 )
        out_ind = newnode_ind;
        Nodes{out_ind} = out_node_label;
        newnode_ind =newnode_ind + 1;
    end
    G(gate,out_ind) = 1;
    not_Inputs(out_ind) = 1;
    
    %Process and insert each of input nodes  in the matrix G and in Nodes
    fan_in = element_words-2;
    for in = 2:fan_in+1
        curr_in_ind = find(ismember(Nodes,element{in}));
        [d , found ] = size(curr_in_ind);
        if (found == 0 )
            curr_in_ind = newnode_ind;
            Nodes{curr_in_ind} = element{in};
            newnode_ind =newnode_ind + 1;
        end
        G(gate,curr_in_ind) = -1;
    end
    
    tline = fgetl(fID);
    gate = gate+1;
end
fclose(fID);





    [g,n]  = size(G);

Inputs = not(not_Inputs);
if (length(Inputs)<n)
    Inputs = [Inputs ones(1,n-length(Inputs))];
end

    Level = repmat(-1,1,8);
    index = 1;
        for i = 1:n
            if Inputs(i)
                inputs_ind(index) = i;
                index = index+1;
            end
        end

        [d , n_PI] = size(inputs_ind);    
    
 %Levelize Netlist   
    for gate = 1:g
        Levelize(gate);            
    end

    
 %Create Execution Order
     lvl_cpy = Level;
    for i = 1:g
        [m,minindex] = min(lvl_cpy);
        Order(i)= minindex;
        lvl_cpy(minindex) = inf;
    end
    
    CC_temp = ['#include <iostream> \n#include <string> \n#include "gates.h" \n\n#define n_PI ' num2str(n_PI) '\n#define n_NET ' num2str(n) '\nstring node_lbl[n_NET] = {'];
    for i = [1:(n-1)]
        CC_temp = [CC_temp '"' Nodes{i} '" ,'];
    end
    CC_temp = [CC_temp '"' Nodes{n} '" };\nint PI[n_PI] = {' ];
    for i = inputs_ind(1:(n_PI-1)) 
        CC_temp = [CC_temp  num2str(i-1) ' ,'];
    end
    CC_temp = [CC_temp  num2str(inputs_ind(n_PI)-1) ' };\n']
    CC_temp = [CC_temp '\nextern void propagate()\n{\n'];
    
    
    
    for i = Order %Generate C code for evaluation of node values by level order
        curr_in= Fan_In(i);
        curr_out= Fan_Out(i);
        [d , curr_fan_in] = size(curr_in);
            CC_temp = [CC_temp '\tnet[' num2str(curr_out) ']\t=\t' gate_type{i}  '( net[' num2str(curr_in(1)) ']' ];
            if (curr_fan_in > 1)
                for j = 2:curr_fan_in
                    CC_temp = [CC_temp ' , net[' num2str(curr_in(j)) ']' ];
                end
            end           
            CC_temp = [CC_temp ' );\n'];     
    end
    
    CC_temp = [CC_temp '}\n'];
    CC_string = CC_temp;
    
    fileID = fopen('prop.h','w');
    fprintf(fileID,CC_string);
    fclose(fileID);
    
    
    
    
    
    function lev = Levelize(gate)
        if (Level(gate) ~= -1);
        else
            ins = Fan_In(gate); % find node indexes that are input to "gate"
            [d,curr_fan_in] = size(ins);
            for k = 1:curr_fan_in
                if Inputs(ins(k)) L(k)  = 0;
                else
                    L(k) = Levelize(Source(ins(k)));
                end
            end
            Level(gate) = max(L)+1;
        end
        lev = Level(gate);
    end

    function in = Fan_In(gate)
        in = find(G(gate,:)==-1); % find node indexes that are input to "gate"
    end

    function out = Fan_Out(gate)
        out = find(G(gate,:)==1);
    end

    function src = Source(node)
       src =  find(G(:,node)==1); % find gate index that "node" is its output
    end

    




end




