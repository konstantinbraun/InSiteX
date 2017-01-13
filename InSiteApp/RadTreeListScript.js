var treeList1;

function findParentItem(element) {
    if (element.tagName.toLowerCase() === "html")
        return null;
    while (!(element.id !== "" && typeof element.tagName !== "undefined" && element.tagName.toLowerCase() === "tr")) {
        if (element.parentNode === null)
            return null;
        element = element.parentNode;
    }
    return element;
}

function get_isTreeListChild(elem) {
    var isInTreeList1 = $telerik.isDescendant(treeList1.get_element(), elem);
    return isInTreeList1;
}

function get_dropTarget(domEvent) {
    return domEvent.srcElement || domEvent.target;
}

function itemDragging(sender, args) {
    var isChild;
    var dropClue = $telerik.findElement(args.get_draggedContainer(), "DropClue");
    args.set_dropClueVisible(true);  //drop clue is always visible

    if (!args.get_canDrop()) //trying to drag a parent item onto its own child
    {
        dropClue.className = "dropClue dropDisabled";
        return;
    }

    isChild = $telerik.isDescendant(treeList1.get_element(), get_dropTarget(args.get_domEvent()));

    var className = isChild ? "dropEnabled" : "dropDisabled"; //Change drop clue icon depending on the drop target             
    args.set_canDrop(isChild);
    dropClue.className = "dropClue " + className;
}

function itemDropping(sender, args) {
    var targetRow = findParentItem(args.get_destinationHtmlElement());
    // radalert("Drop!");
    //Target row is null or not a child of RadTreeList -> Cancel
    if (targetRow === null || !get_isTreeListChild(targetRow)) {
        args.set_cancel(true);
        return;
    }

    var itm = args.get_draggedItems()[0];
    var employeeID = $find(targetRow.id).get_dataKeyValue("CompanyID");

    //Target row is descendant of the sender -> Reorder operation
    if ($telerik.isDescendant(sender.get_element(), targetRow)) {
        //itm.fireCommand("CustomItemsDropped", employeeID); //Fire custom command
        return;
    }

    // radalert(employeeID);
    //itm.fireCommand("CustomItemsDropped", employeeID); //Fire custom command
}

function OnItemClick(sender, args) {
    // radalert("Click!");
    args.get_item().fireCommand("ItemClick", args.get_item().get_dataKeyValue("CompanyID"));
}

function onRequestStart(sender, args) {
    if (args.get_eventTarget().indexOf("btnExportExcel") >= 0) {
        args.set_enableAjax(false);
    }
}
