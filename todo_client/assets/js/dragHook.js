
import Sortable from 'sortablejs';

export default {
  mounted() {
    let dragged;
    const hook = this;

    const selector = '#' + this.el.id;


    document.querySelectorAll('.dropzone').forEach((dropzone) => {
      console.log("DRAGGED");
      new Sortable(dropzone, {
        animation: 0,
        delay: 50,
        delayOnTouchOnly: true,
        group: 'shared',
        draggable: '.draggable',
        ghostClass: 'sortable-ghost',
        onEnd: function (evt) {
          console.log("draggedID: " + evt.item.id.replace("task_", ""));
          console.log("dropzoneID: " + evt.to.id.replace("list_", ""));
          console.log("draggableIndex: " + evt.newDraggableIndex);
          console.log("newIndex: " + evt.newIndex)
          console.log("currentOrder: " + evt.item.order)
          console.log(evt)
          hook.pushEventTo(selector, 'dropped', {
            draggedId: evt.item.id.replace("task_", ""),
            dropzoneId: evt.to.id.replace("list_", ""),
            newOrder: evt.newIndex,
            new_list_id: evt.to.id.replace("list_", "")
          });
        },
      });
    });
  },
};
