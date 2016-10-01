function fnc_DrawGraph(StateSeq)

stateList = unique(StateSeq);

adMatrix = zeros(size(stateList,1));
prevNode = StateSeq(1,:);
for i = 2:size(StateSeq,1)
    curNode = StateSeq(i,:);
    if (prevNode ~= curNode)
%         curNodeID = find((stateList(:,1)==curNode(1)) & (stateList(:,2)==curNode(2)));
%         prevNodeID = find((stateList(:,1)==prevNode(1)) & (stateList(:,2)==prevNode(2)));
        adMatrix(prevNode,curNode) = 1;
    end
    prevNode = curNode;
end

DG = sparse(adMatrix);
tgraph = biograph(DG);
view(tgraph)